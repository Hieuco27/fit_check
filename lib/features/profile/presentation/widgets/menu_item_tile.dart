import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/profile/domain/entities/profile_menu_item.dart';
import 'package:fit_check/core/utils/text_styles.dart';
import 'package:fit_check/core/constants/app_colors.dart';

class MenuItemTile extends StatelessWidget {
  final ProfileMenuItem item;
  final VoidCallback onTap;

  const MenuItemTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.homeSurfaceAlt,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: AppColors.homeTextPrimary,
              size: 22.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyles.titleMedium(color: AppColors.homeTextPrimary).copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.homeTextSecondary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
