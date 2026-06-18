import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/home/domain/entities/home_action.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class ActionCard extends StatelessWidget {
  final HomeAction action;
  final VoidCallback onTap;

  const ActionCard({super.key, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: action.cardBackgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon Container
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: action.iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(action.icon, color: action.iconColor, size: 20.sp),
              ),
            ),
            // Text Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  style: AppTextStyles.titleMedium(
                    color: action.titleColor,
                  ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  action.subtitle,
                  style: AppTextStyles.bodyMedium().copyWith(
                    color: action.subtitleColor,
                    fontSize: 11.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
