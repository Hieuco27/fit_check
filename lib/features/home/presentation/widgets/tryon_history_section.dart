import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section 5: Try-on History - split-view comparison cards
class TryonHistorySection extends StatelessWidget {
  const TryonHistorySection({super.key});

  static const List<Map<String, String>> _historyItems = [
    {
      'resultUrl':
          'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=600&auto=format&fit=crop&q=80',
      'portraitUrl':
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=150&auto=format&fit=crop&q=80',
      'garmentUrl':
          'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=150&auto=format&fit=crop&q=80',
    },
    {
      'resultUrl':
          'https://images.unsplash.com/photo-1485518882345-15568b007407?w=600&auto=format&fit=crop&q=80',
      'portraitUrl':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&auto=format&fit=crop&q=80',
      'garmentUrl':
          'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=150&auto=format&fit=crop&q=80',
    },
    {
      'resultUrl':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=600&auto=format&fit=crop&q=80',
      'portraitUrl':
          'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=150&auto=format&fit=crop&q=80',
      'garmentUrl':
          'https://images.unsplash.com/photo-1585487000160-6ebcfceb0d03?w=150&auto=format&fit=crop&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const BouncingScrollPhysics(),
        itemCount: _historyItems.length,
        itemBuilder: (context, index) {
          return _buildHistoryCard(_historyItems[index]);
        },
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, String> item) {
    return Container(
      width: 165.w,
      margin: EdgeInsets.only(right: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF7B2FFF).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2FFF).withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item['resultUrl']!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: const Color(0xFF1A1A26));
              },
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF1A1A26)),
            ),
            // Dark gradient at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 90.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
            ),
            // AI badge
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B2FFF), Color(0xFF00D4FF)],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome,
                        color: Colors.white, size: 9.sp),
                    SizedBox(width: 3.w),
                    Text(
                      'AI',
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Thumbnail previews at bottom
            Positioned(
              bottom: 10.h,
              left: 10.w,
              child: Row(
                children: [
                  _buildThumbnail(item['portraitUrl']!, Icons.person),
                  SizedBox(width: 6.w),
                  _buildThumbnail(item['garmentUrl']!, Icons.checkroom),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String imageUrl, IconData fallbackIcon) {
    return Container(
      width: 44.w,
      height: 52.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: const Color(0xFF2A2A3A),
              child: Icon(fallbackIcon,
                  color: Colors.white38, size: 18.sp),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF2A2A3A),
            child:
                Icon(fallbackIcon, color: Colors.white38, size: 18.sp),
          ),
        ),
      ),
    );
  }
}
