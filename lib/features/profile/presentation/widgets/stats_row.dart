import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class StatsRow extends StatelessWidget {
  final int outfitsSaved;
  final int stylesAnalyzed;

  const StatsRow({
    super.key,
    required this.outfitsSaved,
    required this.stylesAnalyzed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            Icons.checkroom_outlined,
            outfitsSaved.toString(),
            'OUTFITS SAVED',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            Icons.smart_toy_outlined,
            stylesAnalyzed.toString(),
            'STYLES ANALYZED',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String statValue, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.homeDivider,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon circle
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: AppColors.homeAccentCream,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.homeAccentBrown,
              size: 18.sp,
            ),
          ),
          SizedBox(height: 8.h),
          // Stat count
          Text(
            statValue,
            style: AppTextStyles.headlineLarge().copyWith(
              color: AppColors.homeTextPrimary,
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2.h),
          // Label
          Text(
            label,
            style: AppTextStyles.bodyMedium().copyWith(
              color: AppColors.homeTextSecondary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
