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
    await Future.delayed(const Duration(milliseconds: 300));

    // ── Mock Actions — màu theo bảng Warm Cream & Brown ──
    final mockActions = [
      // Card 0: Primary — nâu đậm nổi bật nhất
      const HomeAction(
        title: 'Chụp ảnh bạn',
        subtitle: 'Cập nhật ảnh người',
        icon: Icons.person_add_alt_1_outlined,
        iconColor: Color(0xFFE8D5C0),       // kem nâu sáng
        iconBackgroundColor: Color(0xFF5A3D2B), // nâu trung
        cardBackgroundColor: Color(0xFF3D2B1F), // nâu đậm
        titleColor: Color(0xFFFAF7F2),      // trắng kem
        subtitleColor: Color(0xFFC8906A),   // nâu nhạt
      ),
      // Card 1, 2, 3: Secondary — nền trắng, icon nâu
      const HomeAction(
        title: 'Chụp quần áo',
        subtitle: 'Thêm món đồ mới',
        icon: Icons.checkroom_outlined,
        iconColor: Color(0xFF90553A),       // nâu nhấn
        iconBackgroundColor: Color(0xFFE8D5C0), // kem nâu
        cardBackgroundColor: Color(0xFFFFFFFF), // trắng
        titleColor: Color(0xFF1F150E),      // đen nâu
        subtitleColor: Color(0xFF8A6E5A),   // nâu xám
      ),
      const HomeAction(
        title: 'Thử đồ ngay',
        subtitle: 'Dùng ảnh đã có',
        icon: Icons.auto_awesome_outlined,
        iconColor: Color(0xFF90553A),
        iconBackgroundColor: Color(0xFFE8D5C0),
        cardBackgroundColor: Color(0xFFFFFFFF),
        titleColor: Color(0xFF1F150E),
        subtitleColor: Color(0xFF8A6E5A),
      ),
      const HomeAction(
        title: 'Tìm trong shop',
        subtitle: 'Duyệt sản phẩm',
        icon: Icons.search_outlined,
        iconColor: Color(0xFF90553A),
        iconBackgroundColor: Color(0xFFE8D5C0),
        cardBackgroundColor: Color(0xFFFFFFFF),
        titleColor: Color(0xFF1F150E),
        subtitleColor: Color(0xFF8A6E5A),
      ),
    ];

    // ── Mock Recent Tries — 3 items như trong thiết kế ──
    final mockRecentTries = [
      const RecentTry(
        title: 'Áo bomber',
        timeAgo: '2 ngày trước',
        imageUrl:
            'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400&auto=format&fit=crop&q=80',
        isAiGenerated: true,
      ),
      const RecentTry(
        title: 'Váy midi',
        timeAgo: 'Hôm qua',
        imageUrl:
            'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&auto=format&fit=crop&q=80',
        isAiGenerated: true,
      ),
      const RecentTry(
        title: 'Jeans xanh',
        timeAgo: '3 ngày trước',
        imageUrl:
            'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&auto=format&fit=crop&q=80',
        isAiGenerated: true,
      ),
    ];

    // ── Mock Daily Suggestion ──
    const mockSuggestion = Suggestion(
      title: 'Gợi ý hôm nay',
      subtitle: 'Thử áo sơ mi trắng với quần của bạn!',
    );

    emit(HomeLoaded(
      userName: 'Minh Anh',
      actions: mockActions,
      recentTries: mockRecentTries,
      dailySuggestion: mockSuggestion,
      activeTabIndex: 0,
    ));
  }

  void _onTabChanged(TabChanged event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(activeTabIndex: event.index));
    }
  }
}
