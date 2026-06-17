import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/tryon/domain/entities/clothing_item.dart';
import 'package:fit_check/features/tryon/presentation/widgets/item_card.dart';

class ItemTray extends StatelessWidget {
  final List<ClothingItem> items;
  final List<ClothingItem> selectedItems;
  final Function(ClothingItem) onItemTap;

  const ItemTray({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SizedBox(
        height: 165.h,
        child: const Center(
          child: Text('Không có sản phẩm nào trong danh mục này'),
        ),
      );
    }

    return SizedBox(
      height: 165.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedItems.any((e) => e.id == item.id);

          return ItemCard(
            item: item,
            isSelected: isSelected,
            onTap: () => onItemTap(item),
          );
        },
      ),
    );
  }
}
