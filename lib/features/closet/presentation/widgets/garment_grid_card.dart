import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GarmentGridCard extends StatelessWidget {
  final String imageUrl;
  final bool isNew;
  final VoidCallback onTryOnTap;

  const GarmentGridCard({
    super.key,
    required this.imageUrl,
    this.isNew = false,
    required this.onTryOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24), // Dark grey container background
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          // Garment Image (Cover style for Unsplash mocks)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7B2FFF),
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white24,
                  size: 32.sp,
                ),
              ),
            ),
          ),

          // 'MỚI' (New) Badge
          if (isNew)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF212121),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.white24, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  'Mới',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

          // Quick Try-On Hanger Icon
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: onTryOnTap,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 0.5),
                ),
                child: Icon(
                  Icons.checkroom_outlined, // Hanger icon
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
