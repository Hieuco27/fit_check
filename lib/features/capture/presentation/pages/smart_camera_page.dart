import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/features/capture/data/repositories/capture_repository_impl.dart';
import 'package:fit_check/features/capture/domain/entities/captured_image.dart';
import 'package:fit_check/features/capture/domain/usecases/analyze_garment_usecase.dart';
import 'package:fit_check/features/capture/domain/usecases/analyze_portrait_usecase.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_bloc.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_event.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_state.dart';
import 'package:fit_check/features/capture/presentation/widgets/garment_frame_overlay.dart';
import 'package:fit_check/features/capture/presentation/widgets/human_silhouette_overlay.dart';
import 'package:fit_check/features/capture/presentation/widgets/mode_slider_widget.dart';

/// Màn Hình 1: Smart Camera — giao diện camera tối giản như Instagram/TikTok.
/// BlocProvider được tạo ở đây để lifecycle gắn với page này.
class SmartCameraPage extends StatelessWidget {
  const SmartCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CaptureRepositoryImpl();
    return BlocProvider(
      create: (_) => CameraBloc(
        analyzePortrait: AnalyzePortraitUseCase(repo),
        analyzeGarment: AnalyzeGarmentUseCase(repo),
      )..add(const InitCameraEvent()),
      child: const _SmartCameraView(),
    );
  }
}

class _SmartCameraView extends StatelessWidget {
  const _SmartCameraView();

  @override
  Widget build(BuildContext context) {
    // Ẩn status bar để camera full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<CameraBloc, CameraState>(
        // BlocConsumer: lắng nghe navigation, đồng thời rebuild UI
        listener: (context, state) {
          if (state is PortraitAnalyzed || state is GarmentAnalyzed) {
            // Khi phân tích xong → navigate sang Màn Hình 2
            // Truyền cả state và bloc instance qua extra
            context.push('/canvas', extra: {
              'state': state,
              'bloc': context.read<CameraBloc>(),
            });
          }
          if (state is CameraError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        // BlocBuilder chỉ rebuild những phần cần thiết
        buildWhen: (prev, curr) {
          // Không rebuild khi chuyển sang trạng thái analyze (đã navigate)
          return curr is! PortraitAnalyzed && curr is! GarmentAnalyzed;
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. Camera Preview (KHÔNG bọc trong BlocBuilder riêng) ──
              _buildCameraLayer(context, state),

              // ── 2. Overlay Guides (chỉ rebuild khi mode thay đổi) ──
              _buildOverlayLayer(state),

              // ── 3. UI Controls (top bar + bottom controls) ──────────────
              _buildControlsLayer(context, state),

              // ── 4. Loading spinner khi chụp ──────────────────────────────
              if (state is CameraCapturing || state is CameraInitializing ||
                  state is PortraitAnalyzing || state is GarmentAnalyzing)
                _buildLoadingIndicator(state),
            ],
          );
        },
      ),
    );
  }

  // ─── Camera Preview Layer ─────────────────────────────────────────────────
  Widget _buildCameraLayer(BuildContext context, CameraState state) {
    if (state is CameraReady) {
      return _CameraPreviewWidget(controller: state.controller);
    }
    if (state is CameraInitializing) {
      return const ColoredBox(color: Colors.black);
    }
    if (state is CameraError) {
      return _ErrorView(message: state.message);
    }
    return const ColoredBox(color: Colors.black);
  }

  // ─── Overlay Layer (mode-dependent, shouldRepaint=false) ─────────────────
  Widget _buildOverlayLayer(CameraState state) {
    CameraMode mode = CameraMode.portrait;
    if (state is CameraReady) mode = state.mode;

    // BlocSelector để chỉ rebuild overlay khi mode thay đổi
    return IgnorePointer(
      child: mode == CameraMode.portrait
          ? const HumanSilhouetteOverlay()
          : const GarmentFrameOverlay(),
    );
  }

  // ─── Controls Layer ──────────────────────────────────────────────────────
  Widget _buildControlsLayer(BuildContext context, CameraState state) {
    final isReady = state is CameraReady;
    final mode = isReady ? state.mode : CameraMode.portrait;
    final isFlashOn = isReady ? state.isFlashOn : false;
    final isFront = isReady ? state.isFrontCamera : false;

    return SafeArea(
      child: Column(
        children: [
          // ── Top Bar ────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút đóng
                _CircleIconButton(
                  icon: Icons.close,
                  onTap: () {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    context.pop();
                  },
                ),
                // Page indicator (1/3)
                _PageIndicator(current: 0),
                // Flash toggle
                _CircleIconButton(
                  icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                  isActive: isFlashOn,
                  onTap: isReady
                      ? () => context.read<CameraBloc>().add(const ToggleFlashEvent())
                      : null,
                ),
              ],
            ),
          ),

          const Spacer(),

          // ── Guide text ────────────────────────────────────────────────
          _buildGuideText(mode),
          SizedBox(height: 16.h),

          // ── Mode Slider ───────────────────────────────────────────────
          BlocSelector<CameraBloc, CameraState, CameraMode>(
            selector: (state) => state is CameraReady ? state.mode : CameraMode.portrait,
            builder: (context, activeMode) => ModeSliderWidget(
              activeMode: activeMode,
              onModeChanged: (mode) =>
                  context.read<CameraBloc>().add(SwitchCameraModeEvent(mode)),
            ),
          ),
          SizedBox(height: 24.h),

          // ── Bottom Capture Controls ───────────────────────────────────
          _buildCaptureControls(context, isReady, isFront),
          SizedBox(height: 16.h),

          // ── Tip dưới cùng ─────────────────────────────────────────────
          _buildTipText(mode),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildGuideText(CameraMode mode) {
    final text = mode == CameraMode.portrait
        ? 'Đứng thẳng, đủ người trong khung'
        : 'Đặt đồ vào khung';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCaptureControls(BuildContext context, bool isReady, bool isFront) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Nút gallery
        _CircleIconButton(
          icon: Icons.photo_library_outlined,
          size: 52.w,
          onTap: isReady
              ? () => context.read<CameraBloc>().add(const PickFromGalleryEvent())
              : null,
        ),

        // Nút chụp chính (lớn)
        GestureDetector(
          onTap: isReady
              ? () => context.read<CameraBloc>().add(const CapturePhotoEvent())
              : null,
          child: BlocSelector<CameraBloc, CameraState, CameraMode>(
            selector: (s) => s is CameraReady ? s.mode : CameraMode.portrait,
            builder: (_, mode) => _ShutterButton(isGarmentMode: mode == CameraMode.garment),
          ),
        ),

        // Nút lật camera
        _CircleIconButton(
          icon: Icons.flip_camera_ios_outlined,
          size: 52.w,
          onTap: isReady
              ? () => context.read<CameraBloc>().add(const FlipCameraEvent())
              : null,
        ),
      ],
    );
  }

  Widget _buildTipText(CameraMode mode) {
    final tip = mode == CameraMode.portrait
        ? '💡 Chọn nền sáng, tránh ngược sáng để AI nhận diện tốt hơn'
        : '💡 Nền trắng hoặc tường sáng giúp AI tách đồ chính xác hơn';

    return Text(
      tip,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white60,
        fontSize: 12.sp,
      ),
    );
  }

  Widget _buildLoadingIndicator(CameraState state) {
    String message = 'Đang xử lý...';
    if (state is PortraitAnalyzing) message = 'AI đang nhận diện cơ thể...';
    if (state is GarmentAnalyzing) message = 'AI đang phân tích trang phục...';

    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF4CAF50), strokeWidth: 2.5),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

/// CameraPreview widget tách riêng để tránh rebuild khi state khác thay đổi
class _CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;
  const _CameraPreviewWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.previewSize?.height ?? 1,
          height: controller.value.previewSize?.width ?? 1,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

/// Nút tròn với icon
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;
  final double size;

  const _CircleIconButton({
    required this.icon,
    this.onTap,
    this.isActive = false,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.45),
          border: Border.all(
            color: isActive ? Colors.white : Colors.white24,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFFF5A623) : Colors.white,
          size: (size * 0.45).sp,
        ),
      ),
    );
  }
}

/// Nút chụp chính (khác nhau giữa portrait=trắng và garment=vàng)
class _ShutterButton extends StatelessWidget {
  final bool isGarmentMode;
  const _ShutterButton({required this.isGarmentMode});

  @override
  Widget build(BuildContext context) {
    final inner = isGarmentMode ? const Color(0xFFF5A623) : Colors.white;
    final outer = isGarmentMode
        ? const Color(0xFFF5A623).withOpacity(0.35)
        : Colors.white.withOpacity(0.35);

    return Container(
      width: 76.w,
      height: 76.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: outer,
        border: Border.all(color: inner.withOpacity(0.7), width: 3),
      ),
      child: Center(
        child: Container(
          width: 58.w,
          height: 58.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: inner),
        ),
      ),
    );
  }
}

/// Indicator "1/3" ở top center
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

/// Error view khi camera không khả dụng
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt_outlined, color: Colors.white38, size: 64.sp),
              SizedBox(height: 16.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () =>
                    context.read<CameraBloc>().add(const InitCameraEvent()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5A623),
                ),
                child: const Text('Thử lại', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
