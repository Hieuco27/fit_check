import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';

/// Variant Picker: chọn màu sắc và kích cỡ quần áo.
/// Khi user chọn size/màu → callback onVariantSelected.
/// Widget tách biệt để BlocSelector chỉ rebuild phần này khi variant thay đổi.
class VariantPickerWidget extends StatelessWidget {
  final List<GarmentVariant> variants;
  final GarmentVariant? selectedVariant;
  final ValueChanged<GarmentVariant> onVariantSelected;

  const VariantPickerWidget({
    super.key,
    required this.variants,
    required this.selectedVariant,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách màu unique (không trùng)
    final uniqueColors = <String, GarmentVariant>{};
    for (final v in variants) {
      uniqueColors.putIfAbsent(v.colorHex, () => v);
    }

    // Lấy danh sách size theo màu đang chọn
    final selectedColor = selectedVariant?.colorHex ?? variants.firstOrNull?.colorHex;
    final sizesForColor = variants.where((v) => v.colorHex == selectedColor).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Màu sắc ──────────────────────────────────────────────────────
        Text(
          'Màu sắc',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          children: uniqueColors.values.map((variant) {
            final isSelected = selectedVariant?.colorHex == variant.colorHex;
            return GestureDetector(
              onTap: () {
                // Khi đổi màu → chọn size M của màu đó (hoặc size gần nhất)
                final sameSizeOtherColor = variants.firstWhere(
                  (v) => v.colorHex == variant.colorHex &&
                      v.size == (selectedVariant?.size ?? 'M'),
                  orElse: () => variant,
                );
                onVariantSelected(sameSizeOtherColor);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: variant.color,
                  border: Border.all(
                    color: isSelected ? const Color(0xFFF5A623) : Colors.white24,
                    width: isSelected ? 2.5 : 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFF5A623).withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 14.sp,
                        color: variant.colorHex == 'FFFFFF' ? Colors.black : Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.h),

        // ── Kích cỡ ──────────────────────────────────────────────────────
        Text(
          'Kích cỡ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: sizesForColor.map((variant) {
            final isSelected = selectedVariant?.id == variant.id;
            final outOfStock = !variant.inStock;

            return GestureDetector(
              onTap: outOfStock ? null : () => onVariantSelected(variant),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF5A623)
                      : Colors.white.withOpacity(outOfStock ? 0.03 : 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFF5A623)
                        : outOfStock
                            ? Colors.white12
                            : Colors.white24,
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      variant.size,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : outOfStock
                                ? Colors.white24
                                : Colors.white,
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                    // Gạch ngang khi hết hàng
                    if (outOfStock)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _StrikethroughPainter(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Painter vẽ đường gạch chéo cho size hết hàng
class _StrikethroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
