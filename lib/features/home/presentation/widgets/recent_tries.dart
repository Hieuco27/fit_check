import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_check/features/home/domain/entities/recent_try.dart';
import 'package:fit_check/features/home/presentation/widgets/recent_try_card.dart';
import 'package:fit_check/core/constants/app_colors.dart';

/// Section "Thử gần đây" — danh sách ngang với header có nút "Xem tất cả"
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
        // ── Header: Tiêu đề + "Xem tất cả" ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thử gần đây',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.homeTextPrimary,
              ),
            ),
            GestureDetector(
              onTap: onSeeAllTap ?? () {},
              child: Row(
                children: [
                  Text(
                    'Xem tất cả',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.homeTextSecondary,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.homeTextSecondary,
                    size: 14.sp,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 14.h),

        // ── Danh sách ngang cuộn — lazy render với ListView.builder ──
        SizedBox(
          height: 190.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            // Không dùng padding ngang ở đây vì parent đã có padding 20.w
            itemCount: recentTries.length,
            separatorBuilder: (context, index) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              return RecentTryCard(
                recentTry: recentTries[index],
                onTap: () => onItemTap(index),
                animationIndex: index, // Truyền index để stagger animation
              );
            },
          ),
        ),
      ],
    );
  }
}
