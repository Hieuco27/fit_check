import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// AI Processing Overlay — màn hình chờ khi AI đang ghép đồ.
/// Hiển thị checklist animation từng bước: mỗi bước hoàn thành → tick xanh.
class AiProcessingOverlay extends StatefulWidget {
  final List<String> steps;
  final int currentStepIndex;
  final String portraitImagePath;   // Ảnh người (bên trái)
  final String garmentImagePath;    // Ảnh quần áo (bên phải)

  const AiProcessingOverlay({
    super.key,
    required this.steps,
    required this.currentStepIndex,
    required this.portraitImagePath,
    required this.garmentImagePath,
  });

  @override
  State<AiProcessingOverlay> createState() => _AiProcessingOverlayState();
}

class _AiProcessingOverlayState extends State<AiProcessingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    // Shimmer animation cho progress bar
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // ── Tiêu đề ──────────────────────────────────────────────────
              Text(
                'AI đang ghép đồ...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Khoảng 3–5 giây',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 30.h),

              // ── Ảnh người + mũi tên + quần áo ───────────────────────────
              _buildImageCombineSection(),
              SizedBox(height: 24.h),

              // ── Progress bar shimmer ──────────────────────────────────────
              _buildProgressBar(),
              SizedBox(height: 4.h),
              Text(
                widget.steps[widget.currentStepIndex.clamp(0, widget.steps.length - 1)],
                style: TextStyle(color: Colors.white60, fontSize: 12.sp),
              ),
              SizedBox(height: 28.h),

              // ── Checklist bước xử lý ─────────────────────────────────────
              ...widget.steps.asMap().entries.map((entry) {
                final idx = entry.key;
                final step = entry.value;
                final isDone = idx < widget.currentStepIndex;
                final isActive = idx == widget.currentStepIndex;

                return _StepItem(
                  label: step,
                  isDone: isDone,
                  isActive: isActive,
                );
              }),

              const Spacer(),
              // ── Tip ───────────────────────────────────────────────────────
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Kết quả tốt hơn nếu bạn đứng thẳng và quần áo không bị nhàu.',
                        style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCombineSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Ảnh người
        _ImageThumbnail(
          imagePath: widget.portraitImagePath,
          label: 'Ảnh bạn',
          placeholderIcon: '🧍',
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white54,
            size: 28,
          ),
        ),
        // AI merge icon
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFF5A623), Color(0xFFFF6B6B)],
            ),
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white54,
            size: 28,
          ),
        ),
        // Ảnh quần áo
        _ImageThumbnail(
          imagePath: widget.garmentImagePath,
          label: 'Quần áo',
          placeholderIcon: '👕',
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = widget.steps.isEmpty
        ? 0.0
        : (widget.currentStepIndex + 1) / widget.steps.length;

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (_, __) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4.h,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF5A623)),
          ),
        );
      },
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  final String imagePath;
  final String label;
  final String placeholderIcon;

  const _ImageThumbnail({
    required this.imagePath,
    required this.label,
    required this.placeholderIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white12, width: 1),
            color: const Color(0xFF1A1A1A),
          ),
          clipBehavior: Clip.antiAlias,
          child: imagePath.startsWith('http')
              ? Image.network(imagePath, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(placeholderIcon, style: const TextStyle(fontSize: 32)),
                  ))
              : Image.asset(imagePath, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(placeholderIcon, style: const TextStyle(fontSize: 32)),
                  )),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(color: Colors.white54, fontSize: 11.sp),
        ),
      ],
    );
  }
}

/// Widget hiển thị 1 bước trong checklist
class _StepItem extends StatelessWidget {
  final String label;
  final bool isDone;
  final bool isActive;

  const _StepItem({
    required this.label,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          // Icon trạng thái
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isDone
                ? Container(
                    key: const ValueKey('done'),
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4CAF50),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                  )
                : Container(
                    key: ValueKey('pending_$isActive'),
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive ? const Color(0xFFF5A623) : Colors.white24,
                        width: 2,
                      ),
                      color: isActive
                          ? const Color(0xFFF5A623).withOpacity(0.15)
                          : Colors.transparent,
                    ),
                    child: isActive
                        ? const Padding(
                            padding: EdgeInsets.all(4),
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Color(0xFFF5A623),
                            ),
                          )
                        : null,
                  ),
          ),
          SizedBox(width: 14.w),
          Text(
            label,
            style: TextStyle(
              color: isDone
                  ? Colors.white
                  : isActive
                      ? const Color(0xFFF5A623)
                      : Colors.white38,
              fontSize: 14.sp,
              fontWeight: isDone || isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (isDone) ...[
            const Spacer(),
            const Icon(Icons.check, color: Color(0xFF4CAF50), size: 16),
          ],
        ],
      ),
    );
  }
}
