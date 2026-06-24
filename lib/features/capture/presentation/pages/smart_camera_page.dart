import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/features/capture/data/repositories/capture_repository_impl.dart';
import 'package:fit_check/features/capture/domain/entities/captured_image.dart';
import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';
import 'package:fit_check/features/capture/domain/usecases/analyze_garment_usecase.dart';
import 'package:fit_check/features/capture/domain/usecases/analyze_portrait_usecase.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_bloc.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_event.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_state.dart';
import 'package:fit_check/features/tryon/data/repositories/tryon_repository_impl.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';

/// Màn Hình Camera — giao diện chụp ảnh tự nhiên như iOS/Android
/// Không còn khung guide overlay — chụp ảnh bình thường
class SmartCameraPage extends StatelessWidget {
  /// Mode mở camera: portrait (selfie) hoặc garment (quần áo)
  final CameraMode initialMode;

  /// true → mở cam trước mặc định (portrait/selfie)
  /// false → mở cam sau mặc định (garment)
  final bool useFrontCamera;

  /// Có giá trị khi mở camera selfie sau khi user đã chụp/chọn quần áo.
  final GarmentScan? garmentScanForTryOn;

  const SmartCameraPage({
    super.key,
    this.initialMode = CameraMode.portrait,
    this.useFrontCamera = false,
    this.garmentScanForTryOn,
  });

  @override
  Widget build(BuildContext context) {
    final repo = CaptureRepositoryImpl();
    return BlocProvider(
      create: (_) =>
          CameraBloc(
            analyzePortrait: AnalyzePortraitUseCase(repo),
            analyzeGarment: AnalyzeGarmentUseCase(repo),
          )..add(
            InitCameraEvent(
              initialMode: initialMode,
              useFrontCamera: useFrontCamera,
            ),
          ),
      child: _SmartCameraView(
        initialMode: initialMode,
        garmentScanForTryOn: garmentScanForTryOn,
      ),
    );
  }
}

class _SmartCameraView extends StatelessWidget {
  final CameraMode initialMode;
  final GarmentScan? garmentScanForTryOn;

  const _SmartCameraView({required this.initialMode, this.garmentScanForTryOn});

  @override
  Widget build(BuildContext context) {
    // Full screen immersive — như iOS native camera
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is PortraitAnalyzed) {
            final garmentScan = garmentScanForTryOn;
            if (garmentScan != null) {
              _processTryOnAndOpenCanvas(
                context,
                portraitPath: state.imagePath,
                garmentPath:
                    garmentScan.removedBgImagePath ?? garmentScan.imagePath,
              );
              return;
            }

            // Chụp chân dung từ luồng chính → sang canvas chọn quần áo
            context.push(
              '/canvas',
              extra: {'state': state, 'bloc': context.read<CameraBloc>()},
            );
          }
          if (state is GarmentAnalyzed) {
            // Chụp quần áo xong → bắt user chọn model hệ thống hoặc chụp chân dung.
            context.push(
              '/portrait-picker',
              extra: {'garmentScan': state.garmentScan},
            );
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
        buildWhen: (prev, curr) =>
            curr is! PortraitAnalyzed && curr is! GarmentAnalyzed,
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. Camera Preview (full screen, tự nhiên) 
              _buildCameraLayer(context, state),

              // ── 2. UI Controls hoặc Preview Layer 
              if (state is CapturePreview)
                _buildPreviewLayer(context, state)
              else
                _buildControlsLayer(context, state),

              // ── 3. Loading khi đang chụp / phân tích 
              if (state is CameraCapturing ||
                  state is CameraInitializing ||
                  state is PortraitAnalyzing ||
                  state is GarmentAnalyzing)
                _buildLoadingOverlay(state),
            ],
          );
        },
      ),
    );
  }

  Future<void> _processTryOnAndOpenCanvas(
    BuildContext context, {
    required String portraitPath,
    required String garmentPath,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF90553A),
                strokeWidth: 3,
              ),
              SizedBox(height: 24.h),
              Text(
                'Đang ướm thử trang phục...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final session = await TryonRepositoryImpl().submitTryOn(
      portraitImagePath: portraitPath,
      garmentImagePath: garmentPath,
      variant: const GarmentVariant(
        id: 1,
        size: 'M',
        colorHex: 'FFFFFF',
        colorName: 'Trắng',
        price: 299000,
        stockCount: 10,
      ),
    );

    if (context.mounted) {
      Navigator.of(context).pop();
      context.push(
        '/canvas',
        extra: {
          'portraitImagePath': portraitPath,
          'garmentImagePath': garmentPath,
          'resultImagePath': session.resultImagePath,
        },
      );
    }
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
    // Khi đang preview ảnh chụp, giữ khung màu đen (hoặc hiển thị camera đứng yên)
    if (state is CapturePreview) {
      return SizedBox.expand(
        child: Image.file(File(state.imagePath), fit: BoxFit.cover),
      );
    }
    return const ColoredBox(color: Colors.black);
  }

  // ─── Preview Layer (Bước Xác Nhận Ảnh) ──────────────────────────────────
  Widget _buildPreviewLayer(BuildContext context, CapturePreview state) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(),
          // Bottom Bar
          Container(
            color: const Color(0xFF111111),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.read<CameraBloc>().add(
                    const RetakeCaptureEvent(),
                  ),
                  child: Text(
                    'Chụp lại',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (state.mode == CameraMode.portrait) {
                      context.read<CameraBloc>().add(
                        const ConfirmPortraitEvent(),
                      );
                    } else {
                      context.read<CameraBloc>().add(
                        const ConfirmGarmentEvent(),
                      );
                    }
                  },
                  child: Text(
                    'Sử dụng ảnh',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Controls Layer ──────────────────────────────────────────────────────
  Widget _buildControlsLayer(BuildContext context, CameraState state) {
    final isReady = state is CameraReady;
    final mode = isReady ? state.mode : initialMode;
    final isFlashOn = isReady ? state.isFlashOn : false;
    final isFront = isReady ? state.isFrontCamera : false;

    return SafeArea(
      child: Column(
        children: [
          // ── Top Bar ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút đóng
                _CircleIconButton(
                  icon: Icons.close,
                  onTap: () {
                    SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.edgeToEdge,
                    );
                    context.pop();
                  },
                ),

                // Label mode hiện tại
                _ModeLabel(mode: mode),

                // Flash toggle (chỉ hiện khi cam sau)
                isFront
                    ? SizedBox(width: 44.w) // Placeholder giữ cân đối
                    : _CircleIconButton(
                        icon: isFlashOn
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        isActive: isFlashOn,
                        onTap: isReady
                            ? () => context.read<CameraBloc>().add(
                                const ToggleFlashEvent(),
                              )
                            : null,
                      ),
              ],
            ),
          ),

          const Spacer(),

          // ── Tip nhỏ phía trên nút chụp ───────────────────────────────
          _buildTipText(mode),
          SizedBox(height: 16.h),

          // ── Mode Switcher ─────────────────────────────────────────────
          BlocSelector<CameraBloc, CameraState, CameraMode>(
            selector: (s) => s is CameraReady ? s.mode : initialMode,
            builder: (context, activeMode) => _ModeTabBar(
              activeMode: activeMode,
              onModeChanged: (m) =>
                  context.read<CameraBloc>().add(SwitchCameraModeEvent(m)),
            ),
          ),
          SizedBox(height: 28.h),

          // ── Bottom: Gallery | Shutter | Flip ─────────────────────────
          _buildCaptureRow(context, isReady, isFront),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildTipText(CameraMode mode) {
    final tip = mode == CameraMode.portrait
        ? '📸 Chụp ảnh toàn thân, nền sáng'
        : '👕 Đặt quần áo phẳng, nền trắng/sáng';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        tip,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.85),
          fontSize: 13.sp,
        ),
      ),
    );
  }

  Widget _buildCaptureRow(BuildContext context, bool isReady, bool isFront) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Nút mở thư viện ảnh
        _CircleIconButton(
          icon: Icons.photo_library_outlined,
          size: 50.w,
          onTap: isReady
              ? () =>
                    context.read<CameraBloc>().add(const PickFromGalleryEvent())
              : null,
        ),

        // Nút chụp chính (shutter) — to và nổi bật
        GestureDetector(
          onTap: isReady
              ? () => context.read<CameraBloc>().add(const CapturePhotoEvent())
              : null,
          child: BlocSelector<CameraBloc, CameraState, CameraMode>(
            selector: (s) => s is CameraReady ? s.mode : CameraMode.portrait,
            builder: (_, mode) =>
                _ShutterButton(isGarmentMode: mode == CameraMode.garment),
          ),
        ),

        // Nút lật camera
        _CircleIconButton(
          icon: Icons.flip_camera_ios_rounded,
          size: 50.w,
          onTap: isReady
              ? () => context.read<CameraBloc>().add(const FlipCameraEvent())
              : null,
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay(CameraState state) {
    String msg = 'Đang xử lý...';
    if (state is PortraitAnalyzing) msg = 'AI đang nhận diện cơ thể...';
    if (state is GarmentAnalyzing) msg = 'AI đang phân tích trang phục...';

    return Container(
      color: Colors.black.withValues(alpha: 0.65),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF90553A),
              strokeWidth: 2.5,
            ),
            SizedBox(height: 16.h),
            Text(
              msg,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

/// Camera preview — tách riêng tránh rebuild
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

/// Label hiển thị mode hiện tại (portrait / garment)
class _ModeLabel extends StatelessWidget {
  final CameraMode mode;
  const _ModeLabel({required this.mode});

  @override
  Widget build(BuildContext context) {
    final isPortrait = mode == CameraMode.portrait;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPortrait ? Icons.person_outline : Icons.checkroom_outlined,
            color: Colors.white,
            size: 15.sp,
          ),
          SizedBox(width: 5.w),
          Text(
            isPortrait ? 'Chụp người' : 'Chụp quần áo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab chuyển mode dưới — thiết kế như iOS camera
class _ModeTabBar extends StatelessWidget {
  final CameraMode activeMode;
  final ValueChanged<CameraMode> onModeChanged;

  const _ModeTabBar({required this.activeMode, required this.onModeChanged});

  static const _items = [
    (mode: CameraMode.portrait, label: 'Chụp người'),
    (mode: CameraMode.garment, label: 'Chụp quần áo'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _items.map((item) {
        final isActive = item.mode == activeMode;
        return GestureDetector(
          onTap: () => onModeChanged(item.mode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.18)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.transparent,
              ),
            ),
            child: Text(
              item.label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
                fontSize: 14.sp,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Nút chụp hình tròn lớn — trắng (portrait) / nâu accent (garment)
class _ShutterButton extends StatelessWidget {
  final bool isGarmentMode;
  const _ShutterButton({required this.isGarmentMode});

  @override
  Widget build(BuildContext context) {
    final innerColor = isGarmentMode ? const Color(0xFF90553A) : Colors.white;
    final outerColor = innerColor.withValues(alpha: 0.3);

    return Container(
      width: 78.w,
      height: 78.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: outerColor,
        border: Border.all(color: innerColor.withValues(alpha: 0.8), width: 3),
      ),
      child: Center(
        child: Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: innerColor),
        ),
      ),
    );
  }
}

/// Nút tròn nhỏ với icon
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
          color: Colors.black.withValues(alpha: 0.45),
          border: Border.all(
            color: isActive ? Colors.white : Colors.white24,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF90553A) : Colors.white,
          size: (size * 0.46).sp,
        ),
      ),
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
              Icon(
                Icons.camera_alt_outlined,
                color: Colors.white38,
                size: 64.sp,
              ),
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
                  backgroundColor: const Color(0xFF90553A),
                ),
                child: const Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
