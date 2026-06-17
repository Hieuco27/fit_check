import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_check/features/home/domain/entities/home_action.dart';
import 'package:fit_check/features/home/domain/entities/recent_try.dart';
import 'package:fit_check/features/home/domain/entities/suggestion.dart';
import 'package:fit_check/features/home/presentation/bloc/home_event.dart';
import 'package:fit_check/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<TabChanged>(_onTabChanged);
  }

  void _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    // Simulate minor delay for fetch simulation
    await Future.delayed(const Duration(milliseconds: 300));

    final mockActions = [
      const HomeAction(
        title: 'Chụp ảnh bạn',
        subtitle: 'Cập nhật ảnh người',
        icon: Icons.person_add_alt_1_outlined,
        iconColor: Color(0xFFA284FF),
        iconBackgroundColor: Color(0xFF454354),
        cardBackgroundColor: Color(0xFF2E2D38),
        titleColor: Colors.white,
        subtitleColor: Color(0xFFB0AEBC),
      ),
      const HomeAction(
        title: 'Chụp quần áo',
        subtitle: 'Thêm món đồ mới',
        icon: Icons.checkroom_outlined,
        iconColor: Color(0xFF7B2CBF),
        iconBackgroundColor: Color(0xFFEAE2FC),
        cardBackgroundColor: Color(0xFFF3EFFF),
        titleColor: Color(0xFF1C1A24),
        subtitleColor: Color(0xFF7E7A8A),
      ),
      const HomeAction(
        title: 'Thử đồ ngay',
        subtitle: 'Dùng ảnh đã có',
        icon: Icons.auto_awesome_outlined,
        iconColor: Color(0xFFB52CFE),
        iconBackgroundColor: Color(0xFFF4EBFF),
        cardBackgroundColor: Color(0xFFF7EFFF),
        titleColor: Color(0xFF1C1A24),
        subtitleColor: Color(0xFF7E7A8A),
      ),
      const HomeAction(
        title: 'Tìm trong shop',
        subtitle: 'Duyệt sản phẩm',
        icon: Icons.search_outlined,
        iconColor: Color(0xFFE65F2B),
        iconBackgroundColor: Color(0xFFFFF1EB),
        cardBackgroundColor: Color(0xFFFFF2EC),
        titleColor: Color(0xFF1C1A24),
        subtitleColor: Color(0xFF7E7A8A),
      ),
    ];

    final mockRecentTries = [
      const RecentTry(
        title: 'Áo bomber',
        timeAgo: '2 ngày trước',
        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400&auto=format&fit=crop&q=80',
        isAiGenerated: true,
      ),
      const RecentTry(
        title: 'Váy midi',
        timeAgo: 'Hôm qua',
        imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&auto=format&fit=crop&q=80',
        isAiGenerated: true,
      ),
    ];

    const mockSuggestion = Suggestion(
      title: 'Gợi ý hôm nay',
      subtitle: 'Thử áo sơ mi trắng với quần của bạn!',
    );

    emit(HomeLoaded(
      userName: 'Minh Anh',
      actions: mockActions,
      recentTries: mockRecentTries,
      dailySuggestion: mockSuggestion,
      activeTabIndex: 0, // Default to Studio/Home
    ));
  }

  void _onTabChanged(TabChanged event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(activeTabIndex: event.index));
    }
  }
}
