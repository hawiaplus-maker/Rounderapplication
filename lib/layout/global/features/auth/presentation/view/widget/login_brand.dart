import 'package:flutter/material.dart';
import 'package:rounder_application/core/images/app_images.dart';

/// Approved login brand slot (design `Login / Brand`): the original orange
/// wordmark, 130×29, centered on a 40px row.
class LoginBrand extends StatelessWidget {
  const LoginBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Image.asset(
          AppImages.rounderWordmark,
          width: 130,
          height: 29,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
