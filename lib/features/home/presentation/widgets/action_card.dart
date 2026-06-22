import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/home/domain/entities/home_action.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';

/// Card hành động trong lưới 2×2 tại trang Home.
///
/// Animation:
/// - [Press Scale] Nhấn xuống → scale 0.95, thả ra → 1.0 với Elastic
/// - [Pulse Glow]  Chỉ card index=0 (nâu đậm): shadow nhịp thở liên tục
class ActionCard extends StatefulWidget {
  final HomeAction action;
  final VoidCallback onTap;

  /// true nếu đây là primary card (card nâu đậm nổi bật, index 0)
  final bool isPrimary;

  const ActionCard({
    super.key,
    required this.action,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard>
    with SingleTickerProviderStateMixin {
  // ── Controller cho Pulse Glow (chỉ dùng khi isPrimary = true) ──
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  // ── Trạng thái Press Scale ──
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // Khởi tạo pulse animation — lặp vô hạn pingPong
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Chỉ chạy animation với primary card
    if (widget.isPrimary) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    // Bắt buộc dispose để tránh memory leak
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact(); // Phản hồi xúc giác nhẹ khi nhấn
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: _isPressed
            ? const Duration(milliseconds: 80)
            : const Duration(milliseconds: 200),
        curve: _isPressed ? Curves.easeIn : Curves.elasticOut,
        child: widget.isPrimary
            ? _buildPrimaryCardWithGlow()
            : _buildSecondaryCard(),
      ),
    );
  }

  // ── PRIMARY CARD: nâu đậm + pulse glow ──
  Widget _buildPrimaryCardWithGlow() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        // Glow shadow nhịp đập — opacity thay đổi từ 0.25 → 0.55
        final glowOpacity = 0.25 + (_pulseAnim.value * 0.30);
        // Blur radius thay đổi từ 12 → 24
        final blurRadius = 12.0 + (_pulseAnim.value * 12.0);

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: widget.action.cardBackgroundColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.homeAccentBrown.withValues(alpha: glowOpacity),
                blurRadius: blurRadius,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        );
      },
      child: _buildCardContent(),
    );
  }

  // ── SECONDARY CARD: nền trắng, shadow nhẹ tĩnh ──
  Widget _buildSecondaryCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.action.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.homeAccentCream.withValues(alpha: 0.8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: AppColors.homeDivider.withValues(alpha: 0.6),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _buildCardContent(),
    );
  }

  // ── Nội dung chung cho cả 2 loại card ──
  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Icon Container
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: widget.action.iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              widget.action.icon,
              color: widget.action.iconColor,
              size: 22.sp,
            ),
          ),
        ),
        // Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.action.title,
              style: AppTextStyles.titleMedium(
                color: widget.action.titleColor,
              ).copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 3.h),
            Text(
              widget.action.subtitle,
              style: AppTextStyles.bodyMedium().copyWith(
                color: widget.action.subtitleColor,
                fontSize: 11.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
