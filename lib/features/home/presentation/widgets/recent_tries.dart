import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/home/domain/entities/recent_try.dart';
import 'package:fit_check/features/home/presentation/widgets/recent_try_card.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class RecentTries extends StatelessWidget {
  final List<RecentTry> recentTries;
  final VoidCallback? onSeeAllTap;
  final Function(int) onItemTap;

  const RecentTries({
    super.key,
    required this.recentTries,
    required this.onItemTap,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thử gần đây',
              style: AppTextStyles.titleMedium(color: const Color(0xFF1F1B2C)).copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            GestureDetector(
              onTap: onSeeAllTap ?? () {},
              child: Row(
                children: [
                  Text(
                    'Xem tất cả',
                    style: AppTextStyles.titleSmall2(color: const Color(0xFF7D7690)).copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward,
                    color: const Color(0xFF7D7690),
                    size: 14.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Horizontal list
        SizedBox(
          height: 195.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recentTries.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              return RecentTryCard(
                recentTry: recentTries[index],
                onTap: () => onItemTap(index),
              );
            },
          ),
        ),
      ],
    );
  }
}
