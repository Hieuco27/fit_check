import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class MetricsCards extends StatelessWidget {
  final double fitScore;
  final String styleCategory;
  final String harmonyCategory;

  const MetricsCards({
    super.key,
    required this.fitScore,
    required this.styleCategory,
    required this.harmonyCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Card 1: Độ vừa vặn (Green)
        Expanded(
          child: _buildMetricItem(
            '${fitScore.toInt()}%',
            'Độ vừa vặn',
            const Color(0xFF2E7D32),
          ),
        ),
        SizedBox(width: 8.w),
        // Card 2: Phong cách (Purple)
        Expanded(
          child: _buildMetricItem(
            styleCategory,
            'Phong cách',
            const Color(0xFF7B2CBF),
          ),
        ),
        SizedBox(width: 8.w),
        // Card 3: Màu sắc (Pink)
        Expanded(
          child: _buildMetricItem(
            harmonyCategory,
            'Màu sắc',
            const Color(0xFFEC407A),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(String val, String label, Color valColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFF1EFF4),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: AppTextStyles.titleMedium().copyWith(
              color: valColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTextStyles.bodyMedium().copyWith(
              color: const Color(0xFF7D7690),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
