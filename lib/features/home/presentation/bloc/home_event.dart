import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class TabChanged extends HomeEvent {
  final int index;

  const TabChanged(this.index);

  @override
  List<Object?> get props => [index];
}
