import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileData extends ProfileEvent {
  const LoadProfileData();
}

class SignOutPressed extends ProfileEvent {
  const SignOutPressed();
}
