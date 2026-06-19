import 'package:flutter/material.dart';
import 'package:fit_check/features/capture/domain/entities/body_profile.dart';

/// HotspotWidget — chấm tròn nhấp nháy để người dùng chọn vùng cơ thể.
/// Dùng RepaintBoundary để isolate animation, tránh repaint toàn màn hình.
class HotspotWidget extends StatefulWidget {
  final HotspotPoint hotspot;
  final Size imageSize;         // Kích thước container ảnh
  final bool isSelected;
  final VoidCallback onTap;

  const HotspotWidget({
    super.key,
    required this.hotspot,
    required this.imageSize,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<HotspotWidget> createState() => _HotspotWidgetState();
}

class _HotspotWidgetState extends State<HotspotWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Animation nhấp nháy liên tục: scale 1.0 → 1.6 → 1.0
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    // Luôn dispose AnimationController để tránh memory leak
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final x = widget.hotspot.x * widget.imageSize.width;
    final y = widget.hotspot.y * widget.imageSize.height;
    const dotSize = 20.0;

    return Positioned(
      left: x - dotSize / 2,
      top: y - dotSize / 2,
      child: GestureDetector(
        onTap: widget.onTap,
        // RepaintBoundary: isolate vùng animation, không lan ra widget khác
        child: RepaintBoundary(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Vòng ngoài nhấp nháy (pulse ring)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (_, __) {
                  return Transform.scale(
                    scale: widget.isSelected ? 1.0 : _pulseAnimation.value,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isSelected
                            ? const Color(0xFF00E676).withOpacity(0.9)
                            : const Color(0xFF00E676).withOpacity(0.3),
                        border: Border.all(
                          color: widget.isSelected
                              ? const Color(0xFF00E676)
                              : Colors.white.withOpacity(0.8),
                          width: widget.isSelected ? 2.5 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00E676).withOpacity(
                              widget.isSelected ? 0.6 : 0.3,
                            ),
                            blurRadius: widget.isSelected ? 12 : 8,
                            spreadRadius: widget.isSelected ? 3 : 1,
                          ),
                        ],
                      ),
                      // Chấm trung tâm
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              // Label vùng cơ thể
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.hotspot.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
