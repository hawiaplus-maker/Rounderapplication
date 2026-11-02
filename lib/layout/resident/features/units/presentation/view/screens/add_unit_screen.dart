import 'dart:ui' as ui_direction;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/city_model.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/cubit/add_unit_cubit.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/add_unit_form.dart';
import 'package:rounder_application/logic/number_text_logic.dart' show localizedNumber;

/// "Add residence unit" screen (design 03.3a — تفاصيل السكن • مكتملة):
/// collects residence type, floor, unit number, name and area, then posts to
/// `/resident/homes/add-unit`. Address/district/city come from the confirmed
/// address of the previous step (passed in) or are editable.
class AddUnitScreen extends StatelessWidget {
  const AddUnitScreen({super.key, this.confirmedAddress = '', this.district = '', this.cityId});

  final String confirmedAddress;
  final String district;
  final int? cityId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddUnitCubit>()..loadCities(),
      child: _AddUnitBody(confirmedAddress: confirmedAddress, district: district, cityId: cityId),
    );
  }
}

class _AddUnitBody extends StatefulWidget {
  const _AddUnitBody({required this.confirmedAddress, required this.district, this.cityId});

  final String confirmedAddress;
  final String district;
  final int? cityId;

  @override
  State<_AddUnitBody> createState() => _AddUnitBodyState();
}

class _AddUnitBodyState extends State<_AddUnitBody> {
  final form = GlobalKey<FormState>();
  late final TextEditingController addressCtrl = TextEditingController(
    text: widget.confirmedAddress,
  );
  late final TextEditingController districtCtrl = TextEditingController(text: widget.district);
  final unitCtrl = TextEditingController();
  final floorCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  String residenceType = 'apartment';
  String ownershipType = 'owner';
  int? selectedCityId;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    selectedCityId = widget.cityId;
  }

  @override
  void dispose() {
    addressCtrl.dispose();
    districtCtrl.dispose();
    unitCtrl.dispose();
    floorCtrl.dispose();
    nameCtrl.dispose();
    areaCtrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    final cityId = selectedCityId;
    if (cityId == null || cityId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocaleKey.city.tr())));
      return;
    }
    setState(() => busy = true);
    try {
      await context.read<AddUnitCubit>().submit(
        name: nameCtrl.text.trim().isEmpty ? addressCtrl.text.trim() : nameCtrl.text.trim(),
        address: addressCtrl.text.trim(),
        district: districtCtrl.text.trim(),
        cityId: cityId,
        residenceType: residenceType,
        unitNumber: unitCtrl.text.trim(),
        floorNumber: floorCtrl.text.trim().isEmpty ? null : floorCtrl.text.trim(),
        areaSqm: double.tryParse(areaCtrl.text.trim()),
        ownershipType: ownershipType,
        isPrimary: true,
      );
      if (!mounted) return;
      final state = context.read<AddUnitCubit>().state;
      if (state is AddUnitSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocaleKey.addUnitSuccess.tr())));
        Navigator.maybePop(context);
      } else if (state is AddUnitFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddUnitCubit, AddUnitState>(
      listener: (context, state) {
        if (state is AddUnitReady && selectedCityId == null && state.cities.isNotEmpty) {
          selectedCityId = state.cities.first.id;
        }
      },
      builder: (context, state) {
        final cities = state is AddUnitReady
            ? state.cities
            : (state is AddUnitSubmitting
                  ? state.cities
                  : (state is AddUnitFailure ? state.cities : const <City>[]));
        final isLoadingCities = state is AddUnitLoadingCities;
        return Scaffold(
          body: BrandGradientBackdrop(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(onBack: () => Navigator.maybePop(context)),
                    const SizedBox(height: 12),
                    Text(
                      AppLocaleKey.addUnitTitle.tr(),
                      textAlign: TextAlign.start,
                      style: AppTextStyles.extraBold24.copyWith(color: AppColors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocaleKey.addUnitSubtitle.tr(),
                      textAlign: TextAlign.start,
                      style: AppTextStyles.captionRegular13.copyWith(
                        color: AppColors.white.withValues(alpha: .8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AddUnitForm(
                      formKey: form,
                      addressCtrl: addressCtrl,
                      districtCtrl: districtCtrl,
                      unitCtrl: unitCtrl,
                      floorCtrl: floorCtrl,
                      nameCtrl: nameCtrl,
                      areaCtrl: areaCtrl,
                      residenceType: residenceType,
                      onResidenceTypeChanged: (v) => setState(() => residenceType = v),
                      ownershipType: ownershipType,
                      onOwnershipTypeChanged: (v) => setState(() => ownershipType = v),
                      cities: cities,
                      isLoadingCities: isLoadingCities,
                      selectedCityId: selectedCityId,
                      onCityChanged: (v) => setState(() => selectedCityId = v),
                      busy: busy,
                      onSubmit: submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .12),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onBack,
          icon: Icon(
            Directionality.of(context) == ui_direction.TextDirection.rtl
                ? Icons.arrow_back_ios_new
                : Icons.arrow_back_ios_new,
            color: AppColors.white,
          ),
        ),
      ),
      const Spacer(),
      Image.asset(AppImages.rounderWordmark, height: 28, fit: BoxFit.contain),
      const Spacer(),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Builder(
          builder: (context) {
            final lang = context.locale.languageCode;
            return Text(
              AppLocaleKey.stepsProgress.tr(
                namedArgs: {'current': localizedNumber(3, lang), 'total': localizedNumber(3, lang)},
              ),
              style: AppTextStyles.bodySemiBold12.copyWith(color: AppColors.white),
            );
          },
        ),
      ),
    ],
  );
}
