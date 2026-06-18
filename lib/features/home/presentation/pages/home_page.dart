import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fit_check/features/home/presentation/bloc/home_bloc.dart';
import 'package:fit_check/features/home/presentation/bloc/home_event.dart';
import 'package:fit_check/features/home/presentation/bloc/home_state.dart';
import 'package:fit_check/features/home/presentation/widgets/fitroom_header.dart';
import 'package:fit_check/features/home/presentation/widgets/home_nav_bar.dart';
import 'package:fit_check/features/home/presentation/widgets/new_arrivals_section.dart';
import 'package:fit_check/features/home/presentation/widgets/portrait_section.dart';
import 'package:fit_check/features/home/presentation/widgets/section_title.dart';
import 'package:fit_check/features/home/presentation/widgets/shop_section.dart';
import 'package:fit_check/features/home/presentation/widgets/trending_section.dart';
import 'package:fit_check/features/home/presentation/widgets/tryon_history_section.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF0B0B0E),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) {
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
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF7B2FFF)),
            );
          } else if (state is HomeLoaded) {
            return _buildBodyForTab(context, state);
          } else if (state is HomeError) {
            return Center(
              child: Text(
                state.message,
                style: GoogleFonts.inter(color: Colors.red),
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
        return _buildHomeTab(context);
      case 1:
        return _buildPlaceholderScreen(
          context,
          'Tủ Quần Áo',
          Icons.door_sliding_outlined,
        );
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

  // ─────────────────────────────────────────────────────────
  //  HOME TAB — single scrollable page
  // ─────────────────────────────────────────────────────────
  Widget _buildHomeTab(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Status bar spacing
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.of(context).padding.top + 8.h),
            ),

            // HEADER
            SliverToBoxAdapter(
              child: FitRoomHeader(onProTap: () {}, onSettingsTap: () {}),
            ),

            // ── SECTION 1: Ảnh chân dung của bạn ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 20.h, bottom: 12.h),
                child: SectionTitle(
                  title: 'Ảnh chân dung của bạn',
                  showArrow: false,
                ),
              ),
            ),
            SliverToBoxAdapter(child: PortraitSection()),

            // ── SECTION 2: Thêm từ online shop ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
                child: SectionTitle(
                  title: 'Thêm từ online shop',
                  showArrow: false,
                ),
              ),
            ),
            SliverToBoxAdapter(child: ShopSection()),

            // ── SECTION 3: Đồ mới nhất ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
                child: SectionTitle(title: 'Đồ mới nhất ›', showArrow: false),
              ),
            ),
            SliverToBoxAdapter(child: NewArrivalsSection()),

            // ── SECTION 4: Phổ biến 🔥 ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
                child: SectionTitle(title: 'Phổ biến 🔥 ›', showArrow: false),
              ),
            ),
            SliverToBoxAdapter(child: TrendingSection()),

            // ── SECTION 5: Quần áo bạn đã thử ──
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
                child: SectionTitle(
                  title: 'Quần áo bạn đã thử ›',
                  showArrow: false,
                ),
              ),
            ),
            SliverToBoxAdapter(child: TryonHistorySection()),

            // Bottom padding so FAB doesn't cover last section
            SliverToBoxAdapter(child: SizedBox(height: 150.h)),
          ],
        ),

        // ── FLOATING "Bắt đầu thử" BUTTON ──
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildFloatingButton(context),
        ),
      ],
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 4.h + 4.h + bottomPadding;

    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        bottom: navBarHeight + 2.h,
        top: 16.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF0B0B0E).withValues(alpha: 0.95),
            const Color(0xFF0B0B0E),
          ],
          stops: const [0.0, 0.35, 1.0],
        ),
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 54.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FFF), Color(0xFF3B9EFF), Color(0xFF00D4FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FFF).withValues(alpha: 0.55),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF00D4FF).withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  'Bắt đầu thử',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  PLACEHOLDER SCREEN (other tabs)
  // ─────────────────────────────────────────────────────────
  Widget _buildPlaceholderScreen(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF7B2FFF), Color(0xFF00D4FF)],
            ).createShader(bounds),
            child: Icon(icon, size: 64.sp, color: Colors.white),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Chức năng đang được phát triển...',
            style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
