import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rounder_application/core/constants/display_placeholder.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/model/weather_model.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/weather_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';
import 'package:rounder_application/logic/weather_logic.dart';

/// Brand wordmark on the start side and the live location / weather context on
/// the end side. The weather cubit is driven at app level; while it has no
/// data (or failed) the section keeps its `----` placeholders.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.topBarHeight,
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            AppImages.rounderIcon,
            width: 118,
            height: 26,
            fit: BoxFit.contain,
          ),

          const Spacer(),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerEnd,
              child: BlocBuilder<WeatherCubit, WeatherState>(
                builder: (context, state) {
                  final WeatherInfo? info = state is WeatherReady
                      ? state.info
                      : null;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _ContextItem(
                        label: _cityLabel(info),
                        icon: AppImages.homePin,
                        iconSize: 15,
                        gap: 4,
                        style: HomeTextStyles.city,
                      ),
                      const SizedBox(width: 8),
                      _ContextItem(
                        label: _weatherLabel(context, info),
                        icon: _weatherIcon(info),
                        iconSize: 16,
                        gap: 5,
                        style: HomeTextStyles.weather,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The device's city, or the localized default city when the location was
/// unavailable; `----` until (and unless) the geocoder resolved a name.
String _cityLabel(WeatherInfo? info) {
  if (info == null) return DisplayPlaceholder.text;
  if (info.cityFellBack) return AppLocaleKey.weatherDefaultCity.tr();
  final String city = info.city.trim();
  return city.isEmpty ? DisplayPlaceholder.text : city;
}

/// `32° Sunny` — interface digits from weather-logic (Arabic-Indic in Arabic).
String _weatherLabel(BuildContext context, WeatherInfo? info) {
  if (info == null) return DisplayPlaceholder.text;
  final String languageCode = Localizations.localeOf(context).languageCode;
  final String condition = switch (info.kind) {
    WeatherKind.sunny => AppLocaleKey.weatherSunny.tr(),
    WeatherKind.cloudy => AppLocaleKey.weatherPartlyCloudy.tr(),
    WeatherKind.rain => AppLocaleKey.weatherRain.tr(),
    WeatherKind.snow => AppLocaleKey.weatherSnow.tr(),
    WeatherKind.fog => AppLocaleKey.weatherFog.tr(),
    WeatherKind.storm => AppLocaleKey.weatherStorm.tr(),
  };
  return '${weatherCelsiusText(info.tempC, languageCode)} $condition';
}

/// The weather glyph of the current kind; the sun stays while data loads.
String _weatherIcon(WeatherInfo? info) => info == null
    ? AppImages.homeSun
    : switch (info.kind) {
        WeatherKind.sunny => AppImages.homeSun,
        WeatherKind.cloudy => AppImages.homeCloud,
        WeatherKind.rain => AppImages.homeRain,
        WeatherKind.snow => AppImages.homeSnow,
        WeatherKind.fog => AppImages.homeFog,
        WeatherKind.storm => AppImages.homeStorm,
      };

/// Icon-trailing label pair; the icon sits on the outer (left) edge in RTL as
/// in the frame.
class _ContextItem extends StatelessWidget {
  const _ContextItem({
    required this.label,
    required this.icon,
    required this.iconSize,
    required this.gap,
    required this.style,
  });

  final String label;
  final String icon;
  final double iconSize;
  final double gap;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
        SizedBox(width: gap),
        HomeSvgIcon(icon, size: iconSize, color: AppColors.white),
      ],
    );
  }
}
