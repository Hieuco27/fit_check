import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section 2: Online Shop brand circles
class ShopSection extends StatelessWidget {
  const ShopSection({super.key});

  static final List<Map<String, dynamic>> _brands = [
    {'name': 'Gucci', 'logo': 'G', 'bg': Colors.white, 'text': Colors.black},
    {'name': 'Zara', 'logo': 'Z', 'bg': Colors.white, 'text': Colors.black},
    {'name': 'Asos', 'logo': 'A', 'bg': Colors.white, 'text': Colors.black},
    {'name': 'GAP', 'logo': 'G', 'bg': const Color(0xFF002B5E), 'text': Colors.white},
    {'name': 'H&M', 'logo': 'H', 'bg': Colors.white, 'text': const Color(0xFFE2000F)},
    {'name': 'Lululemon', 'logo': 'L', 'bg': Colors.white, 'text': Colors.black},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const BouncingScrollPhysics(),
        itemCount: _brands.length,
        itemBuilder: (context, index) {
          return _buildBrandCircle(_brands[index], index);
        },
      ),
    );
  }

  Widget _buildBrandCircle(Map<String, dynamic> brand, int index) {
    return Container(
      margin: EdgeInsets.only(right: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: brand['bg'] as Color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                brand['logo'] as String,
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: brand['text'] as Color,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            brand['name'] as String,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}
