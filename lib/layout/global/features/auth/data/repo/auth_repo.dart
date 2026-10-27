import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/network/end_points.dart';
import 'package:rounder_application/layout/global/features/auth/data/model/me_model.dart';
import 'package:rounder_application/layout/global/features/auth/data/model/validate_mobile_model.dart';

/// Expected domain failure of the phone journey; [message] is user-facing
/// text — the backend's localized message, or empty when the caller picks
/// its own [AppLocaleKey] fallback.
class PhoneAuthException implements Exception {
  PhoneAuthException(this.message);
  final String message;
}

/// The Hive auth box and its token key: written on successful auth calls,
/// read by the locator's interceptor for every outgoing `Authorization`
/// header and verified from the `me` endpoint when the app boots.
const authBoxName = 'rounder_auth';
const accessTokenKey = 'rounder_access_token';

class AuthRepository {
  AuthRepository(this.api, this.tokenBox);
  final ApiConsumer api;

  /// The Hive auth box caching the bearer token — written after every
  /// successful auth response, read by the locator's interceptor.
  final Box<String> tokenBox;
  Future<void> signIn(String email, String password) async => _save(
    await api.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    ),
  );
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String locale,
  }) async => _save(
    await api.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'phone': phone.isEmpty ? null : phone,
        'locale': locale,
      },
    ),
  );

  /// The phone journey (validate-mobile → register / send-otp), driven by
  /// the approved login's continue action; mobile is the local `05…` form.
  Future<ValidateMobileResponse> validateMobile(String mobile) async =>
      _validated(
        await api.post<Map<String, dynamic>>(
          EndPoints.validateMobile,
          data: {'mobile': mobile},
        ),
      );

  Future<void> sendOtp(String mobile) async => _ensureOk(
    await api.post<Map<String, dynamic>>(
      EndPoints.sendOtp,
      data: {'mobile': mobile},
    ),
  );

  /// Verify-otp of the journey's code step: `{mobile, otp}` against the
  /// validated number's local form. The 200 signs the user in — it carries
  /// `data.token`, cached here exactly like the register response.
  Future<void> verifyOtp({required String mobile, required String otp}) async {
    final response = await api.post<Map<String, dynamic>>(
      EndPoints.verifyOtp,
      data: {'mobile': mobile, 'otp': otp},
    );
    _ensureOk(response);
    await _save(response);
  }

  /// The phone-journey register: all of the approved payload — local `05…`
  /// phone (validate-mobile's `data.mobile`), join name/email credentials
  /// and the matched password pair. The 201 carries `data.token`; it is
  /// cached on success so the completed journey already owns a session.
  Future<void> registerPhone({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await api.post<Map<String, dynamic>>(
      EndPoints.register,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    _ensureOk(response);
    await _save(response);
  }

  /// `{status, message, data}` wrapper of validate-mobile.
  ValidateMobileResponse _validated(Response<Map<String, dynamic>> response) {
    final result = ValidateMobileResponse.fromJson(response.data ?? const {});
    if (!result.status) throw PhoneAuthException(result.message);
    return result;
  }

  /// Explicit-failure contract of send-otp / register: Dio already rejects
  /// every non-2xx before this runs, so only a body that states
  /// `status: false` is a failure — a bare `{data: …}` 201 register success
  /// carries no status flag and passes straight through.
  void _ensureOk(Response<Map<String, dynamic>> response) {
    final json = response.data;
    if (json != null && json['status'] == false) {
      throw PhoneAuthException(json['message']?.toString() ?? '');
    }
  }

  Future<void> _save(Response<Map<String, dynamic>> response) async {
    final token = response.data?['data']?['token'];
    if (token is! String || token.isEmpty) throw const FormatException('Missing access token');
    await tokenBox.put(accessTokenKey, token);
  }

  /// The boot-time session check (`GET me`): the response carries the user
  /// data directly with no status wrapper — anything that doesn't parse to
  /// a [MeModel] (no data, an empty object, a stray 200) throws, and the
  /// cubit's catch falls to the login branch.
  Future<MeModel> me() async {
    final response = await api.get<Map<String, dynamic>>(EndPoints.me);
    final data = response.data?['data'];
    if (data is! Map<String, dynamic>) throw PhoneAuthException('');
    final me = MeModel.fromJson(data);
    if (me.id == null) throw PhoneAuthException('');
    return me;
  }

  Future<bool> hasSession() async =>
      tokenBox.get(accessTokenKey)?.isNotEmpty ?? false;
  Future<void> signOut() async {
    try {
      await api.post(EndPoints.logout);
    } on DioException {
      /* clear local credentials even if offline */
    }
    await tokenBox.delete(accessTokenKey);
  }
}
