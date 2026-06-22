import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Ô ảnh vuông trong photo grid
/// Khi chọn: border vàng nâu + scale nhẹ + tick overlay
class PhotoGridItem extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  /// Nếu true → đây là ô Camera đặc biệt (item đầu tiên)
  final bool isCameraItem;

  const PhotoGridItem({
    super.key,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
    this.isCameraItem = false,
  });

  /// Constructor đặc biệt cho ô Camera
  const PhotoGridItem.camera({super.key, required this.onTap})
    : imageUrl = '',
      isSelected = false,
      isCameraItem = true;

  @override
  Widget build(BuildContext context) {
    if (isCameraItem) return _buildCameraItem();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ảnh
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                cacheHeight: 300, // Giới hạn để tối ưu bộ nhớ
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(color: const Color(0xFF1A1A1A));
                },
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1A1A1A),
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white24,
                    size: 24.sp,
                  ),
                ),
              ),
            ),

            // ── Border khi chọn ───────────────────────────────────────────
            if (isSelected)
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: const Color(0xFF90553A),
                      width: 3,
                    ),
                    color: const Color(0xFF90553A).withValues(alpha: 0.15),
                  ),
                ),
              ),

            // ── Tick khi chọn ─────────────────────────────────────────────
            if (isSelected)
              Positioned(
                bottom: 6.w,
                right: 6.w,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF90553A),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 12.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Ô Camera — nền tối + icon camera trung tâm
  Widget _buildCameraItem() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, color: Colors.white60, size: 28.sp),
            SizedBox(height: 4.h),
            Text(
              'Camera',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
