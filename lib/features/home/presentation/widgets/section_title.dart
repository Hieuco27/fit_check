import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool showArrow;
  final VoidCallback? onArrowTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.showArrow = true,
    this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          if (showArrow) ...[
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: onArrowTap,
              child: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.5),
                size: 22.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
