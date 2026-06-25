import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/theme/app_theme.dart';
import 'package:fit_check/core/utils/text_styles.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_bloc.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_event.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_state.dart';
import 'package:fit_check/features/tryon/presentation/widgets/tryon_canvas.dart';
import 'package:fit_check/features/tryon/presentation/widgets/category_selector.dart';
import 'package:fit_check/features/tryon/presentation/widgets/item_tray.dart';
import 'package:fit_check/features/tryon/presentation/widgets/result_app_bar.dart';
import 'package:fit_check/features/tryon/presentation/widgets/metrics_cards.dart';
import 'package:fit_check/features/auth/presentation/widgets/comon/primary_button.dart';

class TryonPage extends StatelessWidget {
  const TryonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TryonBloc()
        ..add(
          const InitSession(
            'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
          ),
        ),
      child: const _TryonView(),
    );
  }
}

class _TryonView extends StatelessWidget {
  const _TryonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFAF8FB,
      ), // Very light purple/pink background
      body: SafeArea(
        child: BlocListener<TryonBloc, TryonState>(
          listener: (context, state) {
            if (state is TryOnSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã lưu phối đồ thành công!'),
                  backgroundColor: AppColors.brandPurple,
                ),
              );
              context.go('/home'); // Return to Home/Studio dashboard
            }
          },
          child: BlocBuilder<TryonBloc, TryonState>(
            builder: (context, state) {
              if (state is TryonInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.brandPurple,
                  ),
                );
              } else if (state is TryOnSelecting) {
                return _buildSelectionView(context, state);
              } else if (state is TryOnGenerating) {
                return _buildGeneratingView();
              } else if (state is TryOnResultLoaded) {
                return _buildResultView(context, state);
              } else if (state is TryOnError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // selection screen
  Widget _buildSelectionView(BuildContext context, TryOnSelecting state) {
    final filteredItems = state.availableItems
        .where((item) => item.category == state.activeCategory)
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go('/home'),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.brandPurple,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Phối đồ ảo',
                style: AppTextStyles.titleMedium(
                  color: AppColors.brandPurple,
                ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Canvas
          TryonCanvas(
            imagePath: state.originalImagePath,
            showPins: true,
            onPinTap: (category) {
              context.read<TryonBloc>().add(ChangeCategory(category));
            },
          ),
          SizedBox(height: 20.h),
          // Category selector title
          Text(
            'Chọn đồ thử',
            style: AppTextStyles.titleMedium(
              color: const Color(0xFF1F1B2C),
            ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          // Category tabs
          CategorySelector(
            selectedCategory: state.activeCategory,
            categories: const ['Quần áo', 'Áo khoác', 'Phụ kiện'],
            onCategorySelected: (category) {
              context.read<TryonBloc>().add(ChangeCategory(category));
            },
          ),
          SizedBox(height: 16.h),
          // Item tray
          ItemTray(
            items: filteredItems,
            selectedItems: state.selectedItems,
            onItemTap: (item) {
              context.read<TryonBloc>().add(SelectClothing(item));
            },
          ),
          SizedBox(height: 24.h),
          // TryOn Submit Button
          PrimaryButton(
            text: 'Ướm thử trang phục',
            gradient: AppGradients.loginButton,
            trailingIcon: const Icon(Icons.auto_awesome, color: Colors.white),
            onPressed: state.selectedItems.isEmpty
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Vui lòng chọn ít nhất 1 sản phẩm để thử!',
                        ),
                      ),
                    );
                  }
                : () {
                    context.read<TryonBloc>().add(const ProcessTryOn());
                  },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  // loading view during simulated AI rendering
  Widget _buildGeneratingView() {
    return const Center(
      child: TryonCanvas(
        imagePath:
            'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
        isGenerating: true,
      ),
    );
  }

  // result screen
  Widget _buildResultView(BuildContext context, TryOnResultLoaded state) {
    final session = state.session;
    final displayImage = state.showAfter
        ? session.resultImagePath!
        : session.originalImagePath;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // AppBar
          ResultAppBar(
            onBackTap: () {
              // Return to selecting screen
              context.read<TryonBloc>().add(
                InitSession(session.originalImagePath),
              );
            },
            onSaveTap: () {
              // Confirm and save outfit
              context.read<TryonBloc>().add(const ConfirmOutfit());
            },
          ),
          SizedBox(height: 12.h),
          // Before / After segmented toggle
          Center(
            child: Container(
              width: 200.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EFF4),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  // Before Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<TryonBloc>().add(
                          const ToggleBeforeAfter(false),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !state.showAfter
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: !state.showAfter
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Trước',
                            style:
                                AppTextStyles.titleSmall(
                                  color: !state.showAfter
                                      ? const Color(0xFF1F1B2C)
                                      : const Color(0xFF7D7690),
                                ).copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: !state.showAfter
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // After Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<TryonBloc>().add(
                          const ToggleBeforeAfter(true),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: state.showAfter
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: state.showAfter
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Sau (AI)',
                            style:
                                AppTextStyles.titleSmall(
                                  color: state.showAfter
                                      ? const Color(0xFF1F1B2C)
                                      : const Color(0xFF7D7690),
                                ).copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: state.showAfter
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Canvas showing result
          TryonCanvas(imagePath: displayImage, showPins: false),
          SizedBox(height: 20.h),
          // Metrics Row
          MetricsCards(
            fitScore: session.fitScore,
            styleCategory: session.styleCategory,
            harmonyCategory: session.harmonyCategory,
          ),
          SizedBox(height: 20.h),
          // Shop Finder Button
          SizedBox(
            height: 48.h,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tính năng tìm cửa hàng đang được phát triển...',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Tìm mua sản phẩm này',
                    style: AppTextStyles.titleSmall(
                      color: Colors.white,
                    ).copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Bottom Actions Row (Đổi đồ khác & Chia sẻ)
          Row(
            children: [
              // Change Clothing Button
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<TryonBloc>().add(
                        InitSession(session.originalImagePath),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFD6D6E0),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: const Color(0xFF1F1B2C),
                          size: 16.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Đổi đồ khác',
                          style:
                              AppTextStyles.titleSmall(
                                color: const Color(0xFF1F1B2C),
                              ).copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Share Button
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Tính năng chia sẻ đang được phát triển...',
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFD6D6E0),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_outlined,
                          color: const Color(0xFF1F1B2C),
                          size: 16.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Chia sẻ',
                          style:
                              AppTextStyles.titleSmall(
                                color: const Color(0xFF1F1B2C),
                              ).copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
