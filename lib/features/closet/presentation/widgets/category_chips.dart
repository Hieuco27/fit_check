import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.activeCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = category == activeCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isActive ? Colors.white : const Color(0xFF1E1E24),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Text(
                category,
                style: GoogleFonts.inter(
                  color: isActive ? const Color(0xFF0B0B0E) : Colors.white,
                  fontSize: 13.sp,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
