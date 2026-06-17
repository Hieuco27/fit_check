import 'package:equatable/equatable.dart';
import 'package:fit_check/features/home/domain/entities/home_action.dart';
import 'package:fit_check/features/home/domain/entities/recent_try.dart';
import 'package:fit_check/features/home/domain/entities/suggestion.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final String userName;
  final List<HomeAction> actions;
  final List<RecentTry> recentTries;
  final Suggestion dailySuggestion;
  final int activeTabIndex;

  const HomeLoaded({
    required this.userName,
    required this.actions,
    required this.recentTries,
    required this.dailySuggestion,
    required this.activeTabIndex,
  });

  HomeLoaded copyWith({
    String? userName,
    List<HomeAction>? actions,
    List<RecentTry>? recentTries,
    Suggestion? dailySuggestion,
    int? activeTabIndex,
  }) {
    return HomeLoaded(
      userName: userName ?? this.userName,
      actions: actions ?? this.actions,
      recentTries: recentTries ?? this.recentTries,
      dailySuggestion: dailySuggestion ?? this.dailySuggestion,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
    );
  }

  @override
  List<Object?> get props => [
        userName,
        actions,
        recentTries,
        dailySuggestion,
        activeTabIndex,
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
