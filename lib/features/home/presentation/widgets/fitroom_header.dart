import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FitRoomHeader extends StatelessWidget {
  final VoidCallback? onProTap;
  final VoidCallback? onSettingsTap;

  const FitRoomHeader({super.key, this.onProTap, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gradient "FitRoom" title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color.fromARGB(255, 255, 255, 255), Color(0xFF90553A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              'FitCheck',
              style: GoogleFonts.inter(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const Spacer(),
          //PRO badge
          GestureDetector(
            onTap: onProTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B2FFF), Color(0xFF5B00E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B2FFF).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.diamond_outlined,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'PRO',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Settings icon
          GestureDetector(
            onTap: onSettingsTap,
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2A),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: Colors.white.withOpacity(0.85),
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
