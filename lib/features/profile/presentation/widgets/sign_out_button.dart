import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/utils/text_styles.dart';

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
          color: const Color(0xFFFFF1F3), // Light pinkish-red background
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: const Color(0xFFFFD5DB),
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
                      color: const Color(0xFFE53935), // Pure Red
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Sign Out',
                      style: AppTextStyles.titleSmall(color: const Color(0xFFE53935)).copyWith(
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
