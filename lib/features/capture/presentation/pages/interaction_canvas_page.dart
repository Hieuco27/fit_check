import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_bloc.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_event.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_state.dart';
import 'package:fit_check/features/capture/presentation/widgets/garment_preview_card.dart';
import 'package:fit_check/features/capture/presentation/widgets/hotspot_widget.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';

/// Màn Hình 2: Interaction Canvas — xem trước ảnh và chọn vùng cơ thể / xác nhận đồ.
/// Reuse CameraBloc từ SmartCameraPage (truyền qua go_router extra).
class InteractionCanvasPage extends StatelessWidget {
  const InteractionCanvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Khôi phục SystemUI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          // Khi user tap hotspot → navigate sang Màn Hình 3
          if (state is PortraitAnalyzed && state.selectedZone != null) {
            _navigateToTryOn(context, state);
          }
        },
        builder: (context, state) {
          if (state is PortraitAnalyzing) {
            return _buildAnalyzingView('AI đang nhận diện cơ thể...');
          }
          if (state is PortraitAnalyzed) {
            return _buildPortraitCanvas(context, state);
          }
          if (state is GarmentAnalyzing) {
            return _buildAnalyzingView('AI đang phân tích trang phục...');
          }
          if (state is GarmentAnalyzed) {
            return _buildGarmentCanvas(context, state);
          }
          // Fallback
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)));
        },
      ),
    );
  }

  // ─── Portrait Canvas — Hiển thị hotspots ─────────────────────────────────
  Widget _buildPortraitCanvas(BuildContext context, PortraitAnalyzed state) {
    return SafeArea(
      child: Column(
        children: [
          // ── Top Bar ───────────────────────────────────────────────────
          _buildTopBar(
            context,
            title: 'Chọn vùng muốn thay đồ',
            pageIndex: 1,
          ),
          SizedBox(height: 8.h),

          // ── Ảnh + Hotspots ────────────────────────────────────────────
          Expanded(
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                final imageSize = Size(constraints.maxWidth, constraints.maxHeight);
                return Stack(
                  children: [
                    // Ảnh người
                    Positioned.fill(
                      child: _buildImageWidget(state.imagePath),
                    ),
                    // Overlay xanh nhận diện
                    if (state.bodyProfile.isDetected)
                      Positioned(
                        top: 12.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _DetectionBadge(
                            text: '✓ Nhận diện người',
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                    // Hotspots (mỗi cái trong RepaintBoundary riêng)
                    ...state.bodyProfile.hotspots.map((hotspot) {
                      return HotspotWidget(
                        hotspot: hotspot,
                        imageSize: imageSize,
                        isSelected: state.selectedZone == hotspot.zone,
                        onTap: () {
                          context.read<CameraBloc>().add(
                                SelectBodyZoneEvent(hotspot.zone),
                              );
                        },
                      );
                    }),
                  ],
                );
              },
            ),
          ),

          // ── Bottom Panel ──────────────────────────────────────────────
          _buildPortraitBottomPanel(context, state),
        ],
      ),
    );
  }

  Widget _buildPortraitBottomPanel(BuildContext context, PortraitAnalyzed state) {
    return Container(
      color: const Color(0xFF111111),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status AI
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'AI đã nhận diện cơ thể',
                style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Icon(Icons.check, color: Color(0xFF4CAF50), size: 18),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Tư thế tốt • Ánh sáng ổn',
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
          SizedBox(height: 16.h),

          // Chỉ dẫn
          if (state.selectedZone == null)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: Colors.white54, size: 18),
                  SizedBox(width: 10.w),
                  Text(
                    'Chạm vào vùng đồ muốn thay',
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                  ),
                ],
              ),
            ),

          if (state.selectedZone != null) ...[
            // Nút "Dùng ảnh này" (chỉ hiện khi đã chọn zone)
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () => _navigateToTryOn(context, state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dùng ảnh này',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 10.h),

          // Chụp lại
          Center(
            child: GestureDetector(
              onTap: () {
                context.read<CameraBloc>().add(const RetakeCaptureEvent());
                context.pop();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, color: Colors.white54, size: 16),
                  SizedBox(width: 4.w),
                  Text(
                    '↩ Chụp lại',
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Garment Canvas — AI tags + preview ──────────────────────────────────
  Widget _buildGarmentCanvas(BuildContext context, GarmentAnalyzed state) {
    return SafeArea(
      child: Column(
        children: [
          _buildTopBar(
            context,
            title: 'Chụp quần áo muốn thử',
            pageIndex: 1,
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20.h),
              child: GarmentPreviewCard(
                garmentScan: state.garmentScan,
                onTryNow: () => _navigateToTryOnFromGarment(context, state.garmentScan),
                onRetake: () {
                  context.read<CameraBloc>().add(const RetakeCaptureEvent());
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Analyzing loading view ───────────────────────────────────────────────
  Widget _buildAnalyzingView(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF4CAF50),
            strokeWidth: 2.5,
          ),
          SizedBox(height: 16.h),
          Text(message, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
        ],
      ),
    );
  }

  // ─── Navigation helpers ───────────────────────────────────────────────────
  void _navigateToTryOn(BuildContext context, PortraitAnalyzed state) {
    // Mock: dùng garment cố định khi chưa có garment flow
    const mockGarmentPath = 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=400&auto=format&fit=crop&q=80';
    const mockVariant = GarmentVariant(
      id: 2, size: 'M', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 10,
    );

    context.push('/tryon/result', extra: {
      'portraitImagePath': state.imagePath,
      'garmentImagePath': mockGarmentPath,
      'initialVariant': mockVariant,
      'targetZone': state.selectedZone,
    });
  }

  void _navigateToTryOnFromGarment(BuildContext context, GarmentScan scan) {
    const mockPortraitPath = 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80';
    const mockVariant = GarmentVariant(
      id: 2, size: 'M', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 10,
    );

    context.push('/tryon/result', extra: {
      'portraitImagePath': mockPortraitPath,
      'garmentImagePath': scan.imagePath,
      'initialVariant': mockVariant,
      'targetZone': null,
    });
  }

  // ─── Shared UI helpers ────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context, {required String title, required int pageIndex}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                SizedBox(width: 4.w),
                Text('Chụp lại', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
              ],
            ),
          ),
          const Spacer(),
          _PageIndicator(current: pageIndex),
          const Spacer(),
          // Flash placeholder để giữ cân đối
          SizedBox(width: 70.w),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)));
        },
      );
    }
    return Image.file(File(imagePath), fit: BoxFit.cover);
  }
}

class _DetectionBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _DetectionBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int current;
  const _PageIndicator({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 20.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white38,
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }
}
