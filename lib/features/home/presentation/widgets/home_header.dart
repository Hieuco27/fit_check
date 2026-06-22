import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_check/core/constants/app_colors.dart';

/// Header trang Home — Light Theme Warm Brown
/// Hiển thị: Logo "FitCheck AI" | nút thông báo | avatar
/// Bên dưới: Lời chào + tiêu đề chính
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
        // ── Row trên: Logo + Actions ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo "FitCheck AI"
            Text(
              'FitCheck AI',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.homeTextPrimary,
                letterSpacing: 0.3,
              ),
            ),
            const Spacer(),
            // Nút thông báo
            GestureDetector(
              onTap: onNotificationTap ?? () {},
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: AppColors.homeAccentCream,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.homeTextPrimary,
                      size: 22.sp,
                    ),
                  ),
                  // Badge đỏ thông báo
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      width: 9.w,
                      height: 9.w,
                      decoration: const BoxDecoration(
                        color: AppColors.wardroRedText,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            // Avatar người dùng
            GestureDetector(
              onTap: onProfileTap ?? () {},
              child: Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.homeAccentLight,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.homeAccentCream,
                      child: Icon(
                        Icons.person,
                        color: AppColors.homeAccentBrown,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // ── Lời chào + Tiêu đề chính ──
        Text(
          'Chào lại, $userName 👋',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.homeTextSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Hôm nay mặc gì?',
          style: GoogleFonts.inter(
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.homeTextPrimary,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
