import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/network/api_error.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/legal_document.dart';
import 'package:rounder_application/layout/resident/features/account/data/repo/legal_repo.dart';

part 'legal_document_state.dart';

class LegalDocumentCubit extends Cubit<LegalDocumentState> {
  LegalDocumentCubit(this.repo) : super(const LegalDocumentLoading());
  final LegalRepository repo;

  Future<void> load(String slug) async {
    emit(const LegalDocumentLoading());
    try {
      final doc = slug == 'terms' ? await repo.getTerms() : await repo.getPrivacy();
      emit(LegalDocumentReady(doc));
    } catch (e) {
      emit(
        LegalDocumentFailure(
          apiErrorMessage(e) ?? AppLocaleKey.connectionError.tr(),
        ),
      );
    }
  }
}
