import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_check/features/home/domain/entities/recent_try.dart';
import 'package:fit_check/core/constants/app_colors.dart';

/// Card hiển thị một món đồ đã thử gần đây.
///
/// Animation:
/// - [Slide-in] Mỗi card trượt từ phải → trái kèm FadeIn khi xuất hiện.
///   Delay staggered theo [animationIndex] để tạo hiệu ứng cascading.
/// - [Ripple] InkWell cho phản hồi nhấn chuẩn Material.
class RecentTryCard extends StatefulWidget {
  final RecentTry recentTry;
  final VoidCallback onTap;

  /// Index trong list — dùng để tính delay staggered (index * 80ms)
  final int animationIndex;

  const RecentTryCard({
    super.key,
    required this.recentTry,
    required this.onTap,
    this.animationIndex = 0,
  });

  @override
  State<RecentTryCard> createState() => _RecentTryCardState();
}

class _RecentTryCardState extends State<RecentTryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    // Slide từ Offset(0.3, 0) → Offset(0, 0): trượt vào từ bên phải
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Fade từ 0 → 1 đồng thời với slide
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    // Delay staggered: mỗi card delay thêm 80ms
    final delayMs = widget.animationIndex * 80;
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTap: widget.onTap,
          child: SizedBox(
            width: 130.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Ảnh với badge AI ──
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Stack(
                    children: [
                      // Ảnh món đồ
                      Image.network(
                        widget.recentTry.imageUrl,
                        width: 130.w,
                        height: 130.w,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          // Shimmer placeholder khi đang tải
                          return _buildShimmerPlaceholder();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 130.w,
                            height: 130.w,
                            color: AppColors.homeSurfaceAlt,
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 28.sp,
                              color: AppColors.homeAccentLight,
                            ),
                          );
                        },
                      ),

                      // Badge "AI" — nâu đậm theo thiết kế
                      if (widget.recentTry.isAiGenerated)
                        Positioned(
                          bottom: 8.w,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.homeAiBadgeBg,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 10.sp,
                                  color: AppColors.homeAccentCream,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'AI',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.homeTextOnDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h),

                // ── Tên món đồ ──
                Text(
                  widget.recentTry.title,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.homeTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 2.h),

                // ── Thời gian ──
                Text(
                  widget.recentTry.timeAgo,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.homeTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shimmer placeholder — kem nhạt khi ảnh đang load
  Widget _buildShimmerPlaceholder() {
    return Container(
      width: 130.w,
      height: 130.w,
      decoration: BoxDecoration(
        color: AppColors.homeSurfaceAlt,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: SizedBox(
          width: 24.w,
          height: 24.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.homeAccentBrown,
          ),
        ),
      ),
    );
  }
}
