import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';
import 'package:fit_check/features/capture/presentation/bloc/portrait_picker_bloc.dart';
import 'package:fit_check/features/capture/presentation/bloc/portrait_picker_event.dart';
import 'package:fit_check/features/capture/presentation/bloc/portrait_picker_state.dart';
import 'package:fit_check/features/capture/presentation/widgets/photo_grid_item.dart';
import 'package:fit_check/features/capture/presentation/widgets/system_model_card.dart';
import 'package:fit_check/features/tryon/data/repositories/tryon_repository_impl.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';

/// Màn hình "Chọn chân dung" — xuất hiện sau khi AI phân tích quần áo xong.
/// Layout: Model demo (trên) + Photo grid thư viện (dưới)
/// Design: Dark theme, giống hình mẫu
class PortraitPickerPage extends StatelessWidget {
  /// Garment đã chụp/chọn trước đó (null nếu không có)
  final GarmentScan? garmentScan;
  final String? garmentImagePath;
  final bool isUpdating;

  const PortraitPickerPage({
    super.key,
    this.garmentScan,
    this.garmentImagePath,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PortraitPickerBloc, PortraitPickerState>(
      listener: (context, state) {
        if (state is PortraitPickerConfirmed) {
          _processTryOnAndOpenCanvas(context, state.portraitPath);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: Column(
            children: [
              // ── Top Bar ─────────────────────────────────────────────────
              _buildTopBar(context),

              if (state is PortraitPickerLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF90553A),
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              else if (state is PortraitPickerLoaded) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Section Model Demo ─────────────────────────────
                      _buildModelSection(context, state),
                      SizedBox(height: 4.h),

                      // ── Tab Bar ────────────────────────────────────────
                      _buildTabBar(context, state),

                      // ── Photo Grid ─────────────────────────────────────
                      Expanded(child: _buildPhotoGrid(context, state)),
                    ],
                  ),
                ),

                // ── Nút "Thử ngay" (hiện ra khi có selection) ──────────
                _buildConfirmButton(context, state),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _processTryOnAndOpenCanvas(
    BuildContext context,
    String portraitPath,
  ) async {
    final garmentPath =
        garmentScan?.removedBgImagePath ??
        garmentScan?.imagePath ??
        garmentImagePath ??
        'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=600';

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
                style: GoogleFonts.inter(
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
      if (isUpdating) {
        context.pop({
          'portraitImagePath': portraitPath,
          'resultImagePath': session.resultImagePath,
        });
      } else {
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
  }

  // ─── Top Bar ──────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Nút đóng
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),

            const Spacer(),

            // Tiêu đề
            Text(
              'Chọn chân dung',
              style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const Spacer(),

            // Hướng dẫn
            GestureDetector(
              onTap: () {
                // TODO: Show guide bottom sheet
              },
              child: Row(
                children: [
                  Text(
                    'Hướng dẫn',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: const Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  const Icon(
                    Icons.help_outline,
                    color: Color(0xFF4CAF50),
                    size: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Model Hệ Thống
  Widget _buildModelSection(BuildContext context, PortraitPickerLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 10.h),
          child: Text(
            'Thử ảnh demo',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: state.systemModels.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final model = state.systemModels[index];
              return SystemModelCard(
                model: model,
                isSelected: state.selectedModel?.id == model.id,
                onTap: () => context.read<PortraitPickerBloc>().add(
                  SelectSystemModel(model),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Tab Bar ─────────────────────────────────────────────────────────────
  Widget _buildTabBar(BuildContext context, PortraitPickerLoaded state) {
    const tabs = ['Tất cả ảnh', 'Mục ưa thích', 'Ảnh selfie', 'Chân dung'];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value;
          final isActive = i == state.tabIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  context.read<PortraitPickerBloc>().add(SwitchPickerTab(i)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Photo Grid ───────────────────────────────────────────────────────────
  Widget _buildPhotoGrid(BuildContext context, PortraitPickerLoaded state) {
    // Grid có thêm 1 item Camera ở đầu
    final itemCount = state.photos.length + 1;

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Index 0 → nút Camera
        if (index == 0) {
          return PhotoGridItem.camera(
            onTap: () {
              // Navigate sang camera portrait để chụp selfie mới
              if (isUpdating) {
                // If updating, wait for result from camera canvas if possible
                // But /camera pushes /canvas. To keep it simple, we just push /camera.
                context.push(
                  '/camera',
                  extra: {
                    'mode': 'portrait',
                    'useFrontCamera': true,
                    'garmentScan': garmentScan,
                    // Garment image fallback so camera canvas knows what to try on
                    'garmentImagePath': garmentImagePath,
                  },
                );
              } else {
                context.push(
                  '/camera',
                  extra: {
                    'mode': 'portrait',
                    'useFrontCamera': true,
                    'garmentScan': garmentScan,
                  },
                );
              }
            },
          );
        }

        final photoIndex = index - 1;
        final photo = state.photos[photoIndex];

        return PhotoGridItem(
          imageUrl: photo,
          isSelected: state.selectedImagePath == photo,
          onTap: () =>
              context.read<PortraitPickerBloc>().add(SelectPhoto(photo)),
        );
      },
    );
  }

  // ─── Confirm Button ───────────────────────────────────────────────────────
  Widget _buildConfirmButton(BuildContext context, PortraitPickerLoaded state) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: state.hasSelection
          ? Container(
              color: const Color(0xFF0D0D0D),
              padding: EdgeInsets.fromLTRB(
                20.w,
                12.h,
                20.w,
                MediaQuery.of(context).padding.bottom + 12.h,
              ),
              child: Row(
                children: [
                  // Preview ảnh đã chọn
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xFF90553A),
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      state.resolvedPortraitPath ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.white54),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.selectedModel != null
                              ? state.selectedModel!.name
                              : 'Ảnh đã chọn',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Nhấn để ướm thử trang phục',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nút confirm
                  GestureDetector(
                    onTap: () => context.read<PortraitPickerBloc>().add(
                      const ConfirmPortraitSelection(),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF90553A),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Thử ngay',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
