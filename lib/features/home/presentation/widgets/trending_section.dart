import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section 4: Trending - model wearing clothes
class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  static const List<Map<String, String>> _items = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&auto=format&fit=crop&q=80',
      'name': 'Pink Halter',
      'rating': '4.9',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1485518882345-15568b007407?w=400&auto=format&fit=crop&q=80',
      'name': 'White Co-ord',
      'rating': '4.8',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&auto=format&fit=crop&q=80',
      'name': 'Blue Print Set',
      'rating': '4.7',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&auto=format&fit=crop&q=80',
      'name': 'Summer Dress',
      'rating': '4.6',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const BouncingScrollPhysics(),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return _buildTrendingCard(_items[index]);
        },
      ),
    );
  }

  Widget _buildTrendingCard(Map<String, String> item) {
    return Container(
      width: 145.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item['imageUrl']!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: const Color(0xFF1A1A26));
              },
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF1A1A26)),
            ),
            // Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.78),
                    ],
                  ),
                ),
              ),
            ),
            // Info row
            Positioned(
              bottom: 10.h,
              left: 10.w,
              right: 10.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['name']!,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          color: const Color(0xFFFFD600), size: 12.sp),
                      SizedBox(width: 2.w),
                      Text(
                        item['rating']!,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Try-on button
            Positioned(
              bottom: 28.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B2FFF), Color(0xFF00D4FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B2FFF).withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Icon(Icons.auto_awesome,
                    color: Colors.white, size: 12.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
