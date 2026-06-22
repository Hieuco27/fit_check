import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_check/features/home/domain/entities/suggestion.dart';
import 'package:fit_check/core/constants/app_colors.dart';

/// Banner "Gợi ý hôm nay" nằm ở cuối trang Home.
///
/// Animation:
/// - [Arrow Bounce] Icon mũi tên dịch chuyển qua lại +4px liên tục
///   tạo cảm giác kéo mời người dùng nhấn vào.
class SuggestionCard extends StatefulWidget {
  final Suggestion suggestion;
  final VoidCallback onTap;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.onTap,
  });

  @override
  State<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrowController;
  late final Animation<double> _arrowAnim;

  @override
  void initState() {
    super.initState();

    // Arrow bounce: dịch chuyển qua lại 4px, lặp vô hạn
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat(reverse: true);

    _arrowAnim = Tween<double>(begin: 0, end: 5).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.homeSuggestionBorder,
          strokeWidth: 1.5,
          borderRadius: 18.r,
          dashPattern: const [6, 4],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.homeSuggestionBg,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            children: [
              // ── Biểu tượng bóng đèn ──
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColors.homeAccentCream,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '💡',
                    style: TextStyle(fontSize: 22.sp),
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              // ── Nội dung text ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.suggestion.title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.homeTextPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.suggestion.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.homeTextSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              // ── Mũi tên bounce ──
              AnimatedBuilder(
                animation: _arrowAnim,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_arrowAnim.value, 0),
                    child: child,
                  );
                },
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.homeAccentBrown,
                  size: 22.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Custom Painter cho viền dashed ──
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;
  final List<double> dashPattern;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = _buildDashedPath(path, dashPattern);
    canvas.drawPath(dashedPath, paint);
  }

  Path _buildDashedPath(Path source, List<double> pattern) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = pattern[draw ? 0 : 1];
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}
