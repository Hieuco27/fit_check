import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class ResultAppBar extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onSaveTap;

  const ResultAppBar({
    super.key,
    required this.onBackTap,
    required this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: <- Thử lại
          GestureDetector(
            onTap: onBackTap,
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF7D7690),
                  size: 18.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Thử lại',
                  style: AppTextStyles.titleSmall(color: const Color(0xFF7D7690)).copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Center: Kết quả with Sparkles
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_outlined,
                color: Colors.orangeAccent,
                size: 14.sp,
              ),
              Text(
                'Kết quả',
                style: AppTextStyles.titleMedium(color: const Color(0xFF1F1B2C)).copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          // Right: Lưu
          GestureDetector(
            onTap: onSaveTap,
            child: Text(
              'Lưu',
              style: AppTextStyles.titleSmall(color: AppColors.brandPurple).copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
