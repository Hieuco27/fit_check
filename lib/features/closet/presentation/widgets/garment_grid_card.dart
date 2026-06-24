import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_check/core/constants/app_colors.dart';

class GarmentGridCard extends StatelessWidget {
  final String imageUrl;
  final bool isNew;
  final VoidCallback onTryOnTap;

  const GarmentGridCard({
    super.key,
    required this.imageUrl,
    this.isNew = false,
    required this.onTryOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homeSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Garment Image (Cover style for Unsplash mocks)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7B2FFF),
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.homeTextSecondary.withValues(alpha: 0.3),
                  size: 32.sp,
                ),
              ),
            ),
          ),

          // 'MỚI' (New) Badge
          if (isNew)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.homeAccentBrown,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.homeAccentBrown, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.homeAccentBrown.withValues(alpha: 0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  'Mới',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

          // Quick Try-On Hanger Icon
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: onTryOnTap,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: AppColors.homeSurfaceAlt.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.homeDivider, width: 0.5),
                ),
                child: Icon(
                  Icons.checkroom_outlined, // Hanger icon
                  color: AppColors.homeTextPrimary,
                  size: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
