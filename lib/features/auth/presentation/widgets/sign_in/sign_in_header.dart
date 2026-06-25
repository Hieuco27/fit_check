import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sign in',
          style: AppTextStyles.headlineLarge().copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 32.sp,
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
