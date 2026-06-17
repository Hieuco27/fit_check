import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/profile/domain/entities/profile_menu_item.dart';
import 'package:fit_check/features/profile/presentation/widgets/menu_item_tile.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class MenuList extends StatelessWidget {
  final List<ProfileMenuItem> menuItems;
  final Function(ProfileMenuItem) onItemTap;

  const MenuList({
    super.key,
    required this.menuItems,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    // Group items by category
    final categories = <String, List<ProfileMenuItem>>{};
    for (var item in menuItems) {
      categories.putIfAbsent(item.category, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.entries.map((entry) {
        final categoryName = entry.key;
        final items = entry.value;

        return Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Header
              Padding(
                padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                child: Text(
                  categoryName,
                  style: AppTextStyles.bodyMedium().copyWith(
                    color: const Color(0xFF7D7690),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Category Items
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  return MenuItemTile(
                    item: items[index],
                    onTap: () => onItemTap(items[index]),
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
