import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_check/core/constants/app_colors.dart';

class ClosetSearchBar extends StatelessWidget {
  final VoidCallback onFilterTap;

  const ClosetSearchBar({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          // Search Input
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.homeSurfaceAlt,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TextField(
                style: GoogleFonts.inter(
                  color: AppColors.homeTextPrimary,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm trang phục...',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.homeTextSecondary.withValues(alpha: 0.6),
                    fontSize: 14.sp,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.homeTextSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Filter Button
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 44.h,
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.homeSurfaceAlt,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: const Icon(
                Icons.tune_rounded, // Filter icon
                color: AppColors.homeTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
