import 'package:fit_check/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  // ── Auth Gradients ──
  static const LinearGradient loginButton = LinearGradient(
    colors: <Color>[
      AppColors.buttonGradientStartLogin,
      AppColors.buttonGradientEndLogin,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient registerButton = LinearGradient(
    colors: <Color>[
      AppColors.buttonGradientStartRegister,
      AppColors.buttonGradientEndRegister,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
