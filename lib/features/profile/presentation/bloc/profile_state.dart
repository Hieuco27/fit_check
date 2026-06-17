import 'package:equatable/equatable.dart';
import 'package:fit_check/features/profile/domain/entities/profile_user.dart';
import 'package:fit_check/features/profile/domain/entities/profile_menu_item.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileUser user;
  final List<ProfileMenuItem> menuItems;
  final bool isSigningOut;

  const ProfileLoaded({
    required this.user,
    required this.menuItems,
    this.isSigningOut = false,
  });

  ProfileLoaded copyWith({
    ProfileUser? user,
    List<ProfileMenuItem>? menuItems,
    bool? isSigningOut,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      menuItems: menuItems ?? this.menuItems,
      isSigningOut: isSigningOut ?? this.isSigningOut,
    );
  }

  @override
  List<Object?> get props => [user, menuItems, isSigningOut];
}

class SignOutLoading extends ProfileState {
  const SignOutLoading();
}

class SignOutSuccess extends ProfileState {
  const SignOutSuccess();
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
