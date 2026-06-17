import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';
import 'package:fit_check/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fit_check/features/profile/presentation/bloc/profile_event.dart';
import 'package:fit_check/features/profile/presentation/bloc/profile_state.dart';
import 'package:fit_check/features/profile/presentation/widgets/profile_header.dart';
import 'package:fit_check/features/profile/presentation/widgets/user_avatar_card.dart';
import 'package:fit_check/features/profile/presentation/widgets/stats_row.dart';
import 'package:fit_check/features/profile/presentation/widgets/score_updated_card.dart';
import 'package:fit_check/features/profile/presentation/widgets/menu_list.dart';
import 'package:fit_check/features/profile/presentation/widgets/sign_out_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(const LoadProfileData()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FB), // Very light purple/pink background
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is SignOutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged Out Successfully'),
                ),
              );
              // Navigate back to login page
              context.go('/login');
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.brandPurple,
                  ),
                );
              } else if (state is ProfileLoaded) {
                final user = state.user;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeader(
                        onBackTap: () {
                          // Handled as blank as requested
                        },
                        onSettingsTap: () {
                          // Handled as blank as requested
                        },
                      ),
                      SizedBox(height: 24.h),
                      UserAvatarCard(
                        avatarUrl: user.avatarUrl,
                        name: user.name,
                        styleTitle: user.styleTitle,
                        location: user.location,
                        onEditAvatarTap: () {
                          // Handled as blank as requested
                        },
                      ),
                      SizedBox(height: 24.h),
                      StatsRow(
                        outfitsSaved: user.outfitsSaved,
                        stylesAnalyzed: user.stylesAnalyzed,
                      ),
                      SizedBox(height: 24.h),
                      ScoreUpdatedCard(
                        title: user.scoreTitle,
                        description: user.scoreSubtitle,
                        onTap: () {
                          // Handled as blank as requested
                        },
                      ),
                      SizedBox(height: 24.h),
                      MenuList(
                        menuItems: state.menuItems,
                        onItemTap: (item) {
                          // Handled as blank as requested
                        },
                      ),
                      SizedBox(height: 8.h),
                      SignOutButton(
                        isLoading: state.isSigningOut,
                        onTap: () {
                          context.read<ProfileBloc>().add(const SignOutPressed());
                        },
                      ),
                      SizedBox(height: 16.h),
                      // Version text
                      Center(
                        child: Text(
                          'MODA AI v2.4.1 - Intelligent Editorial System',
                          style: AppTextStyles.bodyMedium().copyWith(
                            color: const Color(0xFF7D7690),
                            fontSize: 11.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                );
              } else if (state is ProfileError) {
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
      ),
    );
  }
}
