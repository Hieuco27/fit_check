import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/profile/domain/entities/profile_menu_item.dart';
import 'package:fit_check/core/utils/text_styles.dart';

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
          color: const Color(0xFFF7F5FC), // Very faint purple tint
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: const Color(0xFF1F1B2C),
              size: 22.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyles.titleMedium(color: const Color(0xFF1F1B2C)).copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF7D7690),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
