import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/home/domain/entities/recent_try.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class RecentTryCard extends StatelessWidget {
  final RecentTry recentTry;
  final VoidCallback onTap;

  const RecentTryCard({
    super.key,
    required this.recentTry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with rounded corners & AI badge
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                children: [
                  Image.network(
                    recentTry.imageUrl,
                    width: 140.w,
                    height: 140.w,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 140.w,
                        height: 140.w,
                        color: AppColors.textFieldBorder.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 140.w,
                        height: 140.w,
                        color: AppColors.textFieldBorder.withOpacity(0.3),
                        child: Icon(Icons.broken_image_outlined, size: 30.sp, color: Colors.grey),
                      );
                    },
                  ),
                  if (recentTry.isAiGenerated)
                    Positioned(
                      bottom: 8.w,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 10.sp,
                              color: AppColors.brandPurple,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'AI',
                              style: AppTextStyles.titleSmall3(color: const Color(0xFF1F1B2C)).copyWith(
                                fontSize: 9.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            // Title
            Text(
              recentTry.title,
              style: AppTextStyles.titleMedium(color: const Color(0xFF1F1B2C)).copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            // Time ago
            Text(
              recentTry.timeAgo,
              style: AppTextStyles.bodyMedium().copyWith(
                color: const Color(0xFF7D7690),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
