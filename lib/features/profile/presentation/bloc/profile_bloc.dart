import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_check/features/profile/domain/entities/profile_user.dart';
import 'package:fit_check/features/profile/domain/entities/profile_menu_item.dart';
import 'package:fit_check/features/profile/presentation/bloc/profile_event.dart';
import 'package:fit_check/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<SignOutPressed>(_onSignOutPressed);
  }

  void _onLoadProfileData(LoadProfileData event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    // Simulate short network delay
    await Future.delayed(const Duration(milliseconds: 300));

    const mockUser = ProfileUser(
      name: 'Alex Johnson',
      styleTitle: 'Vanguard Style Enthusiast',
      location: 'Paris, FR',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80',
      outfitsSaved: 124,
      stylesAnalyzed: 38,
      scoreTitle: 'Style Score Updated',
      scoreSubtitle: 'Your preference for "Quiet Luxury" has increased by 15% this month.',
    );

    final mockMenuItems = [
      const ProfileMenuItem(
        title: 'My Closet',
        icon: Icons.shopping_bag_outlined,
        category: 'PERSONAL SPACE',
      ),
      const ProfileMenuItem(
        title: 'Style Preferences',
        icon: Icons.tune_outlined,
        category: 'PERSONAL SPACE',
      ),
      const ProfileMenuItem(
        title: 'Account Settings',
        icon: Icons.manage_accounts_outlined,
        category: 'APPLICATION',
      ),
      const ProfileMenuItem(
        title: 'Help & Support',
        icon: Icons.help_outline,
        category: 'APPLICATION',
      ),
    ];

    emit(ProfileLoaded(user: mockUser, menuItems: mockMenuItems));
  }

  void _onSignOutPressed(SignOutPressed event, Emitter<ProfileState> emit) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(isSigningOut: true));
      // Simulate token invalidation
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const SignOutSuccess());
    }
  }
}
