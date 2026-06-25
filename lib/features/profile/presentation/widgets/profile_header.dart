import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onSettingsTap;

  const ProfileHeader({super.key, this.onBackTap, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Fit Check',
              style: AppTextStyles.titleMedium(color: AppColors.homeTextPrimary)
                  .copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onSettingsTap ?? () {},
          child: Icon(
            Icons.settings_outlined,
            color: AppColors.homeTextPrimary,
            size: 24.sp,
          ),
        ),
      ],
    );
  }
}
