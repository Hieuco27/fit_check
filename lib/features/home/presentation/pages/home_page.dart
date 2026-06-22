import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/features/closet/presentation/pages/closet_page.dart';
import 'package:fit_check/features/home/presentation/bloc/home_bloc.dart';
import 'package:fit_check/features/home/presentation/bloc/home_event.dart';
import 'package:fit_check/features/home/presentation/bloc/home_state.dart';
import 'package:fit_check/features/home/presentation/widgets/action_grid.dart';
import 'package:fit_check/features/home/presentation/widgets/home_header.dart';
import 'package:fit_check/features/home/presentation/widgets/home_nav_bar.dart';
import 'package:fit_check/features/home/presentation/widgets/recent_tries.dart';
import 'package:fit_check/features/home/presentation/widgets/suggestion_card.dart';
import 'package:fit_check/features/profile/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(const LoadHomeData()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    // Dùng dark icons vì nền sáng (Light Theme)
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.homeBackground,
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) {
          // Chỉ rebuild NavBar khi tab thay đổi
          if (previous is HomeLoaded && current is HomeLoaded) {
            return previous.activeTabIndex != current.activeTabIndex;
          }
          return true;
        },
        builder: (context, state) {
          int currentIndex = 0;
          if (state is HomeLoaded) {
            currentIndex = state.activeTabIndex;
          }
          return HomeNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<HomeBloc>().add(TabChanged(index));
            },
          );
        },
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.homeAccentBrown,
                strokeWidth: 2.5,
              ),
            );
          } else if (state is HomeLoaded) {
            return _buildBodyForTab(context, state);
          } else if (state is HomeError) {
            return Center(
              child: Text(
                state.message,
                style: GoogleFonts.inter(color: AppColors.wardroRedText),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBodyForTab(BuildContext context, HomeLoaded state) {
    switch (state.activeTabIndex) {
      case 0:
        return _buildHomeTab(context, state);
      case 1:
        return const ClosetPage();
      case 2:
        return _buildPlaceholderScreen(
          context,
          'Trang Phục',
          Icons.checkroom_outlined,
        );
      case 3:
        return const ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  HOME TAB — Layout mới: Header → Action Grid → Recent Tries → Suggestion
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHomeTab(BuildContext context, HomeLoaded state) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Khoảng cách status bar
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top + 8.h),
        ),

        // ── HEADER: "FitCheck AI" + lời chào + avatar ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: HomeHeader(
              userName: state.userName,
              onNotificationTap: () {},
              onProfileTap: () {},
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 24.h)),

        // ── ACTION GRID: 2×2 card chức năng ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ActionGrid(
              actions: state.actions,
              onActionTap: (index) => _handleActionTap(context, index),
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 28.h)),

        // ── RECENT TRIES: Thử gần đây ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: RecentTries(
              recentTries: state.recentTries,
              onItemTap: (index) {},
              onSeeAllTap: () {},
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 20.h)),

        // ── SUGGESTION BANNER: Gợi ý hôm nay ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SuggestionCard(
              suggestion: state.dailySuggestion,
              onTap: () {},
            ),
          ),
        ),

        // Khoảng padding cuối để NavBar không che nội dung
        SliverToBoxAdapter(child: SizedBox(height: 120.h)),
      ],
    );
  }

  void _handleActionTap(BuildContext context, int index) {
    switch (index) {
      case 0: // Chụp ảnh bạn → Portrait mode, cam trước (selfie)
        context.push('/camera', extra: {
          'mode': 'portrait',
          'useFrontCamera': true,
        });
        break;
      case 1: // Chụp quần áo → Garment mode, cam sau
        context.push('/camera', extra: {
          'mode': 'garment',
          'useFrontCamera': false,
        });
        break;
      case 2: // Thử đồ ngay — dùng ảnh có sẵn (TODO)
        break;
      case 3: // Tìm trong shop (TODO)
        break;
    }
  }

  //  PLACEHOLDER SCREEN (các tab chưa phát triển)
  Widget _buildPlaceholderScreen(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Container(
      color: AppColors.homeBackground,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.homeAccentCream,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40.sp, color: AppColors.homeAccentBrown),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.homeTextPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Chức năng đang được phát triển...',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppColors.homeTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
