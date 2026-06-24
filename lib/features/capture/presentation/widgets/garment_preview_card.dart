import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';

/// Card hiển thị kết quả phân tích quần áo sau khi chụp.
/// Giai đoạn đầu: ảnh gốc + thông tin AI mock (loại, màu, kiểu dáng, tags).
class GarmentPreviewCard extends StatelessWidget {
  final GarmentScan garmentScan;
  final VoidCallback onTryNow;
  final VoidCallback onRetake;

  const GarmentPreviewCard({
    super.key,
    required this.garmentScan,
    required this.onTryNow,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Ảnh quần áo (với badge nhận diện) ─────────────────────────────
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              height: 240.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color(0xFFF5A623).withOpacity(0.8),
                  width: 2,
                ),
                color: Colors.black,
              ),
              clipBehavior: Clip.antiAlias,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: Image.asset(
                  garmentScan.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF1A1A1A),
                    child: Icon(
                      Icons.checkroom_rounded,
                      color: const Color(0xFFF5A623).withOpacity(0.4),
                      size: 80.sp,
                    ),
                  ),
                ),
              ),
            ),
            // Badge nhận diện
            Container(
              margin: EdgeInsets.only(top: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF00C851),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00C851).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check, color: Colors.white, size: 13),
                  SizedBox(width: 5.w),
                  Text(
                    garmentScan.garmentType,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // AI Phân tích
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI phân tích',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.h),
              _InfoRow(
                icon: Icons.checkroom,
                label: 'Loại',
                value: garmentScan.garmentType,
              ),
              _InfoRow(
                icon: Icons.palette,
                label: 'Màu',
                value: garmentScan.color,
              ),
              _InfoRow(
                icon: Icons.style,
                label: 'Kiểu dáng',
                value: garmentScan.style,
              ),
              SizedBox(height: 12.h),
              // Tags
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: garmentScan.tags
                    .map((tag) => _TagChip(tag: tag))
                    .toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // Thử đồ ngay (CTA chính)
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: onTryNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A623),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Thử đồ ngay',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Chụp lại / Lưu vào tủ đồ
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: onRetake,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Colors.white70,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Chụp lại',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, height: 20.h, color: Colors.white24),
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_to_photos_outlined,
                            color: Colors.white70,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Lưu vào tủ đồ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF5A623), size: 16.sp),
          SizedBox(width: 10.w),
          Text(
            label,
            style: TextStyle(color: Colors.white54, fontSize: 13.sp),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.edit_outlined, color: Colors.white38, size: 14.sp),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        tag,
        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
      ),
    );
  }
}
