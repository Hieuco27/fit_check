import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class HomeNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        height: 64.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIconItem(0, Icons.home_outlined),
            _buildIconItem(1, Icons.explore_outlined),
            _buildCenterItem(context),
            _buildIconItem(2, Icons.favorite_border_outlined),
            _buildIconItem(3, Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(int index, IconData icon) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(12.w),
        child: Icon(
          icon,
          color: isSelected ? AppColors.wardroBrown : const Color(0xFF9E9E9E),
          size: 28.sp,
        ),
      ),
    );
  }

  Widget _buildCenterItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/camera');
      },
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: const BoxDecoration(
          color: AppColors.wardroBrown,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.document_scanner_outlined, // Match the scan icon
            color: Colors.white,
            size: 24.sp,
          ),
        ),
      ),
    );
  }
}
