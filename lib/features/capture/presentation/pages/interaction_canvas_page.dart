import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/features/capture/domain/entities/body_profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_bloc.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_event.dart';
import 'package:fit_check/features/capture/presentation/bloc/camera_state.dart';
import 'package:fit_check/features/capture/presentation/widgets/garment_preview_card.dart';
import 'package:fit_check/features/capture/presentation/widgets/garment_selection_panel.dart';
import 'package:fit_check/features/tryon/data/repositories/tryon_repository_impl.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';

class InteractionCanvasPage extends StatefulWidget {
  final String? portraitImagePath;
  final String? garmentImagePath;
  final String? resultImagePath;

  const InteractionCanvasPage({
    super.key,
    this.portraitImagePath,
    this.garmentImagePath,
    this.resultImagePath,
  });

  @override
  State<InteractionCanvasPage> createState() => _InteractionCanvasPageState();
}

class _InteractionCanvasPageState extends State<InteractionCanvasPage> {
  String? _selectedGarmentUrl;
  bool _showOriginal = false;

  @override
  Widget build(BuildContext context) {
    // Khôi phục SystemUI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      backgroundColor: const Color(0xFF16181C), // Màu nền tối đồng bộ
      body: _hasTryOnPreview
          ? _buildTryOnPreviewCanvas(
              context,
              portraitImagePath: widget.portraitImagePath!,
              garmentImagePath: widget.garmentImagePath!,
              resultImagePath: widget.resultImagePath!,
            )
          : BlocConsumer<CameraBloc, CameraState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is PortraitAnalyzing) {
                  return _buildAnalyzingView('AI đang xử lý ảnh chân dung...');
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
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
                );
              },
            ),
    );
  }

  bool get _hasTryOnPreview =>
      widget.portraitImagePath != null &&
      widget.garmentImagePath != null &&
      widget.resultImagePath != null;

  Widget _buildTryOnPreviewCanvas(
    BuildContext context, {
    required String portraitImagePath,
    required String garmentImagePath,
    required String resultImagePath,
  }) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              _buildNewTopBar(
                context,
                onSave: () => _navigateToResult(
                  context,
                  portraitImagePath: portraitImagePath,
                  garmentImagePath: garmentImagePath,
                  resultImagePath: resultImagePath,
                ),
                saveEnabled: true,
              ),
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: _buildImageWidget(
                        _showOriginal ? portraitImagePath : resultImagePath,
                      ),
                    ),
                    Positioned(
                      bottom: 16.h,
                      left: 0,
                      right: 0,
                      child: Center(child: _buildChangePhotoButton(context)),
                    ),
                    Positioned(
                      bottom: 16.h,
                      right: 16.w,
                      child: GestureDetector(
                        onTapDown: (_) => setState(() => _showOriginal = true),
                        onTapUp: (_) => setState(() => _showOriginal = false),
                        onTapCancel: () =>
                            setState(() => _showOriginal = false),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.compare,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: GarmentSelectionPanel(
                  selectedGarmentUrl: _selectedGarmentUrl,
                  onGarmentSelected: (garmentUrl) {
                    setState(() {
                      _selectedGarmentUrl = garmentUrl;
                    });
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 24.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _selectedGarmentUrl == null
                        ? null
                        : () => _navigateToTryOnFromPaths(
                            context,
                            portraitImagePath: portraitImagePath,
                            garmentImagePath: _selectedGarmentUrl!,
                          ),
                    child: Container(
                      height: 54.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _selectedGarmentUrl == null
                            ? const Color(0xFF2B303B)
                            : const Color(0xFF4A90E2),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        'Tạo ảnh',
                        style: GoogleFonts.inter(
                          color: _selectedGarmentUrl == null
                              ? Colors.white54
                              : Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

  // ─── Portrait Canvas — Mới ────────────────────────────────────────────────
  Widget _buildPortraitCanvas(BuildContext context, PortraitAnalyzed state) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              // ── Top Bar mới ───────────────────────────────────────────────
              _buildNewTopBar(context),

              // ── 60%: Ảnh + Nút "Thêm" + Nút "Đổi ảnh" ─────────────────────
              Expanded(
                flex: 6,
                child: LayoutBuilder(
                  builder: (ctx, constraints) {
                    return Stack(
                      children: [
                        // Ảnh người (Full width/height của vùng này)
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: _buildImageWidget(state.imagePath),
                        ),

                        // Nút "Thêm" ở góc trái dưới
                        Positioned(
                          left: 12.w,
                          bottom: 12.h,
                          child: _buildFloatingAddButton(),
                        ),

                        // Nút "Đổi ảnh" ở giữa dưới
                        Positioned(
                          bottom: 16.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _buildChangePhotoButton(context),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ── 40%: Danh sách quần áo ─────────────────────────────────────
              Expanded(
                flex: 4,
                child: GarmentSelectionPanel(
                  selectedGarmentUrl: _selectedGarmentUrl,
                  onGarmentSelected: (garmentUrl) {
                    setState(() {
                      _selectedGarmentUrl = garmentUrl;
                    });
                  },
                ),
              ),
            ],
          ),

          // ── Hai nút nổi "Xem trước" và "Tạo ảnh (2)" ở dưới cùng ──────────
          Positioned(
            bottom: 24.h,
            left: 20.w,
            right: 20.w,
            child: _buildBottomActionButtons(state),
          ),
        ],
      ),
    );
  }

  // ─── Top Bar Theo Thiết Kế ────────────────────────────────────────────────
  Widget _buildNewTopBar(
    BuildContext context, {
    VoidCallback? onSave,
    bool saveEnabled = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Quay Lại
          GestureDetector(
            onTap: () => context.go('/home'),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          ),

          // Nút Undo / Redo
          Row(
            children: [
              Icon(Icons.undo, color: Colors.white38, size: 22.sp),
              SizedBox(width: 24.w),
              Icon(Icons.redo, color: Colors.white38, size: 22.sp),
            ],
          ),

          // Nút Lưu
          GestureDetector(
            onTap: saveEnabled ? onSave : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: saveEnabled
                    ? const Color(0xFF90553A)
                    : const Color(0xFF262A34),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                'Lưu',
                style: GoogleFonts.inter(
                  color: saveEnabled ? Colors.white : Colors.white54,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Các nút nổi trên ảnh
  Widget _buildFloatingAddButton() {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.white, size: 20.sp),
          SizedBox(height: 2.h),
          Text(
            'Thêm',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePhotoButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await context.push<Map<String, String?>>(
          '/portrait-picker',
          extra: {
            'garmentImagePath': widget.garmentImagePath ?? _selectedGarmentUrl,
            'isUpdating': true,
          },
        );
        if (result != null && context.mounted) {
          context.replace(
            '/canvas',
            extra: {
              'portraitImagePath': result['portraitImagePath'],
              'garmentImagePath':
                  widget.garmentImagePath ?? _selectedGarmentUrl,
              'resultImagePath': result['resultImagePath'],
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sync, color: Colors.white, size: 16.sp),
            SizedBox(width: 6.w),
            Text(
              'Đổi ảnh',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Nút hành động nổi ở bottom
  Widget _buildBottomActionButtons(PortraitAnalyzed state) {
    final hasSelection = _selectedGarmentUrl != null;

    return Row(
      children: [
        // Xem trước

        // Tạo ảnh
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: hasSelection
                ? () {
                    _navigateToTryOn(context, state, _selectedGarmentUrl!);
                  }
                : null,
            child: Container(
              height: 54.h,
              decoration: BoxDecoration(
                color: hasSelection
                    ? const Color(0xFF4A90E2)
                    : const Color(0xFF2B303B),
                borderRadius: BorderRadius.circular(16.r),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tạo ảnh',
                    style: GoogleFonts.inter(
                      color: hasSelection ? Colors.white : Colors.white54,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Helpers chung ────────────────────────────────────────────────────────
  Widget _buildAnalyzingView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF4CAF50),
            strokeWidth: 2.5,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  void _navigateToTryOn(
    BuildContext context,
    PortraitAnalyzed state,
    String garmentPath,
  ) async {
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
                'Đang xử lý ảnh ...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Quá trình này có thể mất vài giây, vui lòng không đóng cửa sổ.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final session = await TryonRepositoryImpl().submitTryOn(
      portraitImagePath: state.imagePath,
      garmentImagePath: garmentPath,
      variant: const GarmentVariant(
        id: 2,
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
          'portraitImagePath': state.imagePath,
          'garmentImagePath': garmentPath,
          'resultImagePath': session.resultImagePath,
          'targetZone': state.selectedZone,
        },
      );
    }
  }

  Future<void> _navigateToTryOnFromPaths(
    BuildContext context, {
    required String portraitImagePath,
    required String garmentImagePath,
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
                'Đang xử lý ảnh ...',
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
      portraitImagePath: portraitImagePath,
      garmentImagePath: garmentImagePath,
      variant: const GarmentVariant(
        id: 2,
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
          'portraitImagePath': portraitImagePath,
          'garmentImagePath': garmentImagePath,
          'resultImagePath': session.resultImagePath,
        },
      );
    }
  }

  void _navigateToResult(
    BuildContext context, {
    required String portraitImagePath,
    required String garmentImagePath,
    String? resultImagePath,
    GarmentVariant? initialVariant,
    BodyZone? targetZone,
  }) {
    context.push(
      '/tryon/result',
      extra: {
        'portraitImagePath': portraitImagePath,
        'garmentImagePath': garmentImagePath,
        if (resultImagePath != null) 'resultImagePath': resultImagePath,
        if (initialVariant != null) 'initialVariant': initialVariant,
        if (targetZone != null) 'targetZone': targetZone,
      },
    );
  }

  void _navigateToTryOnFromGarment(BuildContext context, GarmentScan scan) {
    context.push('/portrait-picker', extra: {'garmentScan': scan});
  }

  Widget _buildImageWidget(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) =>
            const Icon(Icons.broken_image, color: Colors.white38, size: 50),
      );
    }
    return Image.file(File(imagePath), fit: BoxFit.cover);
  }

  // ─── Garment Canvas (Tái sử dụng cho Garment mode) ───────────────────────
  Widget _buildGarmentCanvas(BuildContext context, GarmentAnalyzed state) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  'Chụp quần áo muốn thử',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20.h),
              child: GarmentPreviewCard(
                garmentScan: state.garmentScan,
                onTryNow: () =>
                    _navigateToTryOnFromGarment(context, state.garmentScan),
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
}
