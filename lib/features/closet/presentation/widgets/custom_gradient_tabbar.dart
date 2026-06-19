import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGradientTabBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabChanged;

  const CustomGradientTabBar({
    super.key,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Tủ đồ', 'Đã thử', 'Yêu thích'];

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E1E24), width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(tabs.length, (index) {
          final isActive = activeIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Text(
                      tabs[index],
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: isActive ? Colors.white : Colors.white54,
                      ),
                    ),
                  ),
                  // Gradient Indicator
                  if (isActive)
                    Container(
                      height: 3.h,
                      width: 60.w, // Match the sketch width
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7B2FFF), Color(0xFF00D4FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3.r),
                          topRight: Radius.circular(3.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00D4FF,
                            ).withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(height: 3.h), // Placeholder to maintain height
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
