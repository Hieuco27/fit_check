import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';
import 'package:fit_check/features/home/presentation/bloc/home_bloc.dart';
import 'package:fit_check/features/home/presentation/bloc/home_event.dart';
import 'package:fit_check/features/home/presentation/bloc/home_state.dart';
import 'package:fit_check/features/home/presentation/widgets/action_grid.dart';
import 'package:fit_check/features/home/presentation/widgets/home_header.dart';
import 'package:fit_check/features/home/presentation/widgets/home_nav_bar.dart';
import 'package:fit_check/features/home/presentation/widgets/recent_tries.dart';
import 'package:fit_check/features/home/presentation/widgets/suggestion_card.dart';
import 'package:fit_check/features/profile/presentation/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      backgroundColor: const Color(
        0xFFFAF8FB,
      ), // Very light purple/pink background
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
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.brandPurple),
              );
            } else if (state is HomeLoaded) {
              return _buildBodyForTab(context, state);
            } else if (state is HomeError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyLarge(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBodyForTab(BuildContext context, HomeLoaded state) {
    switch (state.activeTabIndex) {
      case 0: // Studio (Home dashboard)
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                userName: state.userName,
                onBackTap: () {
                  // Keep blank as requested
                },
                onNotificationTap: () {
                  // Keep blank as requested
                },
                onProfileTap: () {
                  // Keep blank as requested
                },
              ),
              SizedBox(height: 24.h),
              ActionGrid(
                actions: state.actions,
                onActionTap: (index) {
                  if (index == 0 || index == 2) {
                    context.push('/tryon');
                  }
                },
              ),
              SizedBox(height: 28.h),
              RecentTries(
                recentTries: state.recentTries,
                onItemTap: (index) {
                  // Keep blank as requested
                },
                onSeeAllTap: () {
                  // Keep blank as requested
                },
              ),
              SizedBox(height: 28.h),
              SuggestionCard(
                suggestion: state.dailySuggestion,
                onTap: () {
                  // Keep blank as requested
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      case 1: // Closet placeholder
        return _buildPlaceholderScreen('Closet Screen');
      case 2: // Stylist placeholder
        return _buildPlaceholderScreen('Stylist Screen');
      case 3: // Profile
        return const ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPlaceholderScreen(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard_outlined,
            size: 64.sp,
            color: AppColors.brandPurple.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: AppTextStyles.headlineMedium().copyWith(
              color: AppColors.brandPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Chức năng đang được phát triển...',
            style: AppTextStyles.bodyMedium().copyWith(
              color: const Color(0xFF7D7690),
            ),
          ),
        ],
      ),
    );
  }
}
