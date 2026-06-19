import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/tryon/domain/entities/tryon_session.dart';

/// Badge hiển thị mức độ vừa vặn của quần áo.
/// Màu xanh = True to size, Cam = Loose, Đỏ = Tight.
class FitRatingBadge extends StatelessWidget {
  final FitRating fitRating;

  const FitRatingBadge({super.key, required this.fitRating});

  @override
  Widget build(BuildContext context) {
    final config = _getBadgeConfig(fitRating);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: config.color.withOpacity(0.6), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.color, size: 14.sp),
          SizedBox(width: 6.w),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _getBadgeConfig(FitRating rating) {
    switch (rating) {
      case FitRating.trueToSize:
        return _BadgeConfig(
          color: const Color(0xFF4CAF50),
          icon: Icons.check_circle_outline,
          label: 'Vừa vặn',
        );
      case FitRating.tight:
        return _BadgeConfig(
          color: const Color(0xFFF44336),
          icon: Icons.compress_rounded,
          label: 'Quá chật',
        );
      case FitRating.loose:
        return _BadgeConfig(
          color: const Color(0xFFFF9800),
          icon: Icons.expand_rounded,
          label: 'Quá rộng',
        );
      case FitRating.unknown:
        return _BadgeConfig(
          color: Colors.grey,
          icon: Icons.help_outline,
          label: 'Chưa xác định',
        );
    }
  }
}

class _BadgeConfig {
  final Color color;
  final IconData icon;
  final String label;

  const _BadgeConfig({
    required this.color,
    required this.icon,
    required this.label,
  });
}
