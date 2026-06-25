import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/utils/text_styles.dart';
import 'package:fit_check/core/constants/app_colors.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const SignOutButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 48.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: AppColors.homeDivider,
            width: 1.5,
          ),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFE53935),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      color: AppColors.wardroRedText,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Sign Out',
                      style: AppTextStyles.titleSmall(color: AppColors.wardroRedText).copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
