import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/features/capture/presentation/widgets/ai_processing_overlay.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';
import 'package:fit_check/features/tryon/domain/entities/tryon_session.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_bloc.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_event.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_state.dart';
import 'package:fit_check/features/tryon/presentation/widgets/fit_rating_badge.dart';
import 'package:fit_check/features/tryon/presentation/widgets/nearby_stores_sheet.dart';
import 'package:fit_check/features/tryon/presentation/widgets/variant_picker_widget.dart';

/// Màn Hình 3: TryOn Result — kết quả thử đồ ảo.
/// Layout split-view: 60% ảnh + 40% bottom sheet.
class TryOnResultPage extends StatelessWidget {
  final String portraitImagePath;
  final String garmentImagePath;
  final GarmentVariant initialVariant;

  const TryOnResultPage({
    super.key,
    required this.portraitImagePath,
    required this.garmentImagePath,
    required this.initialVariant,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TryonBloc()
        ..add(SubmitTryOnEvent(
          portraitImagePath: portraitImagePath,
          garmentImagePath: garmentImagePath,
          initialVariant: initialVariant,
        )),
      child: const _TryOnResultView(),
    );
  }
}

class _TryOnResultView extends StatelessWidget {
  const _TryOnResultView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: BlocConsumer<TryonBloc, TryonState>(
        listener: (context, state) {
          // Toast khi lưu thành công
          if (state is TryOnResultLoaded && state.session.saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✓ Đã lưu set đồ!'),
                backgroundColor: const Color(0xFF4CAF50),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          // Toast wishlist
          if (state is TryOnResultLoaded && state.session.inWishlist) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('♡ Đã thêm vào yêu thích!'),
                backgroundColor: const Color(0xFFE91E63),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          // Hiển thị stores sheet
          if (state is StoresLoaded) {
            _showStoresSheet(context, state);
          }
        },
        builder: (context, state) {
          if (state is TryOnProcessing) {
            return AiProcessingOverlay(
              steps: state.steps,
              currentStepIndex: state.currentStepIndex,
              portraitImagePath: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=200',
              garmentImagePath: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=200',
            );
          }

          // ── Re-rendering khi đổi variant ─────────────────────────────
          if (state is TryOnRendering) {
            return Stack(
              children: [
                _buildResultLayout(context, state.previousSession, true, const []),
                // Mini overlay loading trên ảnh
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFFF5A623),
                            strokeWidth: 2.5,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Đang render size ${state.newVariant.size}...',
                            style: TextStyle(color: Colors.white, fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // ── Kết quả đã load ──────────────────────────────────────────
          if (state is TryOnResultLoaded) {
            return _buildResultLayout(
              context,
              state.session,
              state.showAfter,
              state.availableVariants,
            );
          }

          // ── Đang lưu ──────────────────────────────────────────────────
          if (state is TryOnSaving) {
            return Stack(
              children: [
                _buildResultLayout(context, state.session, true, const []),
                Container(color: Colors.black.withOpacity(0.4)),
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF5A623)),
                ),
              ],
            );
          }

          // ── Stores loading ────────────────────────────────────────────
          if (state is StoresLoading) {
            return Stack(
              children: [
                _buildResultLayout(context, state.session, true, const []),
                Container(color: Colors.black.withOpacity(0.4)),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Color(0xFFF5A623)),
                      SizedBox(height: 12.h),
                      Text(
                        'Đang tìm cửa hàng gần bạn...',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // ── Error ─────────────────────────────────────────────────────
          if (state is TryOnError) {
            return _buildErrorView(context, state.message);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ─── Main Result Layout ───────────────────────────────────────────────────
  Widget _buildResultLayout(
    BuildContext context,
    TryonSession session,
    bool showAfter,
    List<GarmentVariant> variants,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Column(
        children: [
          // ── Top Bar ─────────────────────────────────────────────────
          _buildTopBar(context, session),
          SizedBox(height: 8.h),

          // ── 60%: Ảnh kết quả (InteractiveViewer để zoom) ─────────────
          SizedBox(
            height: screenHeight * 0.50,
            child: Stack(
              children: [
                // Ảnh chính
                _ResultImageViewer(
                  imagePath: showAfter
                      ? (session.resultImagePath ?? session.originalImagePath)
                      : session.originalImagePath,
                ),
                // Before/After toggle nổi phía trên ảnh
                Positioned(
                  top: 12.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _BeforeAfterToggle(showAfter: showAfter),
                  ),
                ),
                // FitRating badge góc phải trên
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: BlocSelector<TryonBloc, TryonState, FitRating>(
                    selector: (s) => s is TryOnResultLoaded
                        ? s.session.fitRating
                        : FitRating.unknown,
                    builder: (_, rating) => FitRatingBadge(fitRating: rating),
                  ),
                ),
              ],
            ),
          ),

          // ── 40%: Bottom Sheet thông tin ──────────────────────────────
          Expanded(
            child: _buildBottomSheet(context, session, variants),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, TryonSession session) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
            ),
          ),
          const Spacer(),
          Text(
            'Kết quả thử đồ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // Nút lưu
          GestureDetector(
            onTap: session.saved
                ? null
                : () => context.read<TryonBloc>().add(const SaveSessionEvent()),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: session.saved
                    ? const Color(0xFF4CAF50).withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
              ),
              child: Icon(
                session.saved ? Icons.bookmark : Icons.bookmark_outline,
                color: session.saved ? const Color(0xFF4CAF50) : Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Sheet ─────────────────────────────────────────────────────────
  Widget _buildBottomSheet(
    BuildContext context,
    TryonSession session,
    List<GarmentVariant> variants,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Tên sản phẩm
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.selectedItems.isNotEmpty
                            ? session.selectedItems.first.name
                            : 'Trang phục',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        session.selectedItems.isNotEmpty
                            ? session.selectedItems.first.brandName
                            : '',
                        style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
                if (session.selectedVariant != null)
                  Text(
                    '${_formatPrice(session.selectedVariant!.price)}đ',
                    style: TextStyle(
                      color: const Color(0xFFF5A623),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.h),

            // Variant Picker (BlocSelector → chỉ rebuild phần này)
            if (variants.isNotEmpty)
              BlocSelector<TryonBloc, TryonState, GarmentVariant?>(
                selector: (s) =>
                    s is TryOnResultLoaded ? s.session.selectedVariant : null,
                builder: (context, selectedVariant) {
                  return VariantPickerWidget(
                    variants: variants,
                    selectedVariant: selectedVariant,
                    onVariantSelected: (v) =>
                        context.read<TryonBloc>().add(ChangeVariantEvent(v)),
                  );
                },
              ),
            SizedBox(height: 20.h),

            // Fit score bar
            _buildFitScoreBar(session.fitScore),
            SizedBox(height: 20.h),

            // Action Buttons
            _buildActionButtons(context, session),
          ],
        ),
      ),
    );
  }

  Widget _buildFitScoreBar(double score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Độ phù hợp',
              style: TextStyle(color: Colors.white54, fontSize: 12.sp),
            ),
            Text(
              '${score.toInt()}%',
              style: TextStyle(
                color: const Color(0xFFF5A623),
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 6.h,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(
              score >= 80
                  ? const Color(0xFF4CAF50)
                  : score >= 60
                      ? const Color(0xFFFF9800)
                      : const Color(0xFFF44336),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, TryonSession session) {
    return Column(
      children: [
        // Row 1: Lưu set đồ + Yêu thích
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: session.saved ? Icons.bookmark : Icons.bookmark_outline,
                label: session.saved ? 'Đã lưu' : 'Lưu set đồ',
                color: const Color(0xFF4CAF50),
                isActive: session.saved,
                onTap: session.saved
                    ? null
                    : () => context.read<TryonBloc>().add(const SaveSessionEvent()),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ActionButton(
                icon: session.inWishlist ? Icons.favorite : Icons.favorite_outline,
                label: session.inWishlist ? 'Đã yêu thích' : 'Yêu thích',
                color: const Color(0xFFE91E63),
                isActive: session.inWishlist,
                onTap: session.inWishlist
                    ? null
                    : () => context.read<TryonBloc>().add(const AddWishlistEvent()),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        // Row 2: Tìm cửa hàng (full width, CTA chính)
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: () =>
                context.read<TryonBloc>().add(const FindNearbyStoresEvent()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5A623),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.black, size: 20),
                SizedBox(width: 8.w),
                Text(
                  'Tìm cửa hàng gần nhất',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 56.sp),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5A623),
              ),
              child: const Text('Quay lại', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  void _showStoresSheet(BuildContext context, StoresLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NearbyStoresSheet(
        stores: state.stores,
        size: state.session.selectedVariant?.size ?? 'M',
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    }
    return '${(price ~/ 1000)}K';
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

/// InteractiveViewer để zoom/pan ảnh kết quả
/// TransformationController được dispose đúng cách trong StatefulWidget
class _ResultImageViewer extends StatefulWidget {
  final String imagePath;
  const _ResultImageViewer({required this.imagePath});

  @override
  State<_ResultImageViewer> createState() => _ResultImageViewerState();
}

class _ResultImageViewerState extends State<_ResultImageViewer> {
  // TransformationController phải dispose để tránh memory leak
  final _transformController = TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: InteractiveViewer(
        transformationController: _transformController,
        minScale: 0.5,
        maxScale: 4.0,
        child: widget.imagePath.startsWith('http')
            ? Image.network(
                widget.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: const Color(0xFF1A1A1A),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF5A623),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              )
            : Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
      ),
    );
  }
}

/// Before/After toggle
class _BeforeAfterToggle extends StatelessWidget {
  final bool showAfter;
  const _BeforeAfterToggle({required this.showAfter});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleTab(
            label: 'Trước',
            isActive: !showAfter,
            onTap: () => context.read<TryonBloc>().add(const ToggleBeforeAfterEvent(false)),
          ),
          _ToggleTab(
            label: 'Sau (AI)',
            isActive: showAfter,
            onTap: () => context.read<TryonBloc>().add(const ToggleBeforeAfterEvent(true)),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF0D0D0D) : Colors.white60,
            fontSize: 13.sp,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// Action button tái sử dụng
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48.h,
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isActive ? color.withOpacity(0.5) : Colors.white12,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? color : Colors.white54, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isActive ? color : Colors.white54,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
