import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_check/features/capture/domain/entities/system_model.dart';

/// Card hiển thị model hệ thống — tỉ lệ 3:4 (dọc)
/// Khi chọn: border trắng 2.5px + overlay tick ✓
class SystemModelCard extends StatelessWidget {
  final SystemModel model;
  final bool isSelected;
  final VoidCallback onTap;

  const SystemModelCard({
    super.key,
    required this.model,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 110.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 12.r : 14.r),
          child: Stack(
            children: [
              // ── Ảnh model ──────────────────────────────────────────────
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.network(
                  model.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFF1E1E1E),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white38,
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF1E1E1E),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white38,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),

              // ── Gradient bottom + tên ──────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  child: Text(
                    model.name,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // ── Tick overlay khi chọn ──────────────────────────────────
              if (isSelected)
                Positioned(
                  top: 8.w,
                  right: 8.w,
                  child: Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.black,
                      size: 14.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
