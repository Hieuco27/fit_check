import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class TryonCanvas extends StatefulWidget {
  final String imagePath;
  final bool isGenerating;
  final bool showPins;
  final Function(String)? onPinTap;

  const TryonCanvas({
    super.key,
    required this.imagePath,
    this.isGenerating = false,
    this.showPins = false,
    this.onPinTap,
  });

  @override
  State<TryonCanvas> createState() => _TryonCanvasState();
}

class _TryonCanvasState extends State<TryonCanvas> with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scannerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );

    if (widget.isGenerating) {
      _scannerController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant TryonCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isGenerating && !oldWidget.isGenerating) {
      _scannerController.repeat(reverse: true);
    } else if (!widget.isGenerating && oldWidget.isGenerating) {
      _scannerController.stop();
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFF4),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Image display
            Positioned.fill(
              child: _buildImage(),
            ),
            // Sparkles AI badge top-right overlay
            Positioned(
              top: 16.w,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.brandPurple,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'AI',
                      style: AppTextStyles.titleSmall(color: Colors.white).copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Interactive Pins
            if (widget.showPins && !widget.isGenerating) ...[
              _buildInteractivePin(0.20, 0.50, 'Head', 'Mũ & Kính'),
              _buildInteractivePin(0.40, 0.50, 'Quần áo', 'Áo & Quần'),
              _buildInteractivePin(0.70, 0.40, 'Phụ kiện', 'Túi & Giày'),
            ],
            // Scanner Animation Overlay
            if (widget.isGenerating)
              AnimatedBuilder(
                animation: _scannerAnimation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Semi-transparent blur overlay
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      // Scanning Laser line
                      Positioned(
                        top: 380.h * _scannerAnimation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3.h,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.brandPurple.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 4,
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.brandPurple,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.imagePath.startsWith('http')) {
      return Image.network(
        widget.imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: CircularProgressIndicator(color: AppColors.brandPurple),
          );
        },
        errorBuilder: (context, error, stack) => _buildPlaceholderMannequin(),
      );
    }
    return _buildPlaceholderMannequin();
  }

  Widget _buildPlaceholderMannequin() {
    // Elegant mannequin mockup in case of error
    return Container(
      color: const Color(0xFFF1EFF4),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.accessibility_new_outlined,
              size: 120.sp,
              color: AppColors.brandPurple.withOpacity(0.15),
            ),
            SizedBox(height: 8.h),
            Text(
              'Áo phông trắng',
              style: AppTextStyles.bodyMedium().copyWith(
                color: AppColors.brandPurple.withOpacity(0.5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractivePin(double top, double left, String category, String label) {
    return Positioned(
      top: 380.h * top,
      left: 320.w * left,
      child: GestureDetector(
        onTap: () {
          if (widget.onPinTap != null) {
            widget.onPinTap!(category);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã chọn danh mục: $label'),
              duration: const Duration(milliseconds: 500),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.brandPurple, width: 1.5.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: AppColors.brandPurple,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: AppTextStyles.titleSmall(color: const Color(0xFF1F1B2C)).copyWith(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
