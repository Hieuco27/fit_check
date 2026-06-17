import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    required this.userName,
    this.onBackTap,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Navigation row
        Row(
          children: [
            Text(
              'Fit Check',
              style: AppTextStyles.titleMedium(color: AppColors.brandPurple)
                  .copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
            ),
            const Spacer(),
            // Notification Bell with Badge
            GestureDetector(
              onTap: onNotificationTap ?? () {},
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1EAFF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: const Color(0xFF1F1B2C),
                      size: 22.sp,
                    ),
                  ),
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // User Avatar
            GestureDetector(
              onTap: onProfileTap ?? () {},
              child: CircleAvatar(
                radius: 20.r,
                backgroundImage: const NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Greetings
        Text(
          'Chào bạn, $userName 👋',
          style: AppTextStyles.labelLarge().copyWith(
            color: const Color(0xFF7D7690),
          ),
        ),
        Text('Hôm nay mặc gì?', style: AppTextStyles.titleLarge().copyWith()),
      ],
    );
  }
}
