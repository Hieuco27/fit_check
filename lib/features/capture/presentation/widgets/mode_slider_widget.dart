import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/capture/domain/entities/captured_image.dart';

/// Thanh trượt chế độ camera: [Chụp mẫu người] ↔ [Chụp trang phục]
/// Thiết kế tối giản như Instagram/TikTok.
class ModeSliderWidget extends StatelessWidget {
  final CameraMode activeMode;
  final ValueChanged<CameraMode> onModeChanged;

  const ModeSliderWidget({
    super.key,
    required this.activeMode,
    required this.onModeChanged,
  });

  static const _modes = [
    (mode: CameraMode.portrait, label: 'Chụp mẫu người'),
    (mode: CameraMode.garment, label: 'Chụp trang phục'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _modes.map((item) {
        final isActive = item.mode == activeMode;
        return GestureDetector(
          onTap: () => onModeChanged(item.mode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isActive
                    ? Colors.white.withOpacity(0.6)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Text(
              item.label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : Colors.white.withOpacity(0.55),
                fontSize: 14.sp,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
