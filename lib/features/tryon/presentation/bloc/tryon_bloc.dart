import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_check/features/tryon/domain/entities/clothing_item.dart';
import 'package:fit_check/features/tryon/domain/entities/tryon_session.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_event.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_state.dart';

class TryonBloc extends Bloc<TryonEvent, TryonState> {
  TryonBloc() : super(const TryonInitial()) {
    on<InitSession>(_onInitSession);
    on<ChangeCategory>(_onChangeCategory);
    on<SelectClothing>(_onSelectClothing);
    on<ProcessTryOn>(_onProcessTryOn);
    on<ToggleBeforeAfter>(_onToggleBeforeAfter);
    on<ConfirmOutfit>(_onConfirmOutfit);
  }

  // Mock list of garments matching the data schema
  final List<ClothingItem> _mockGarments = const [
    ClothingItem(
      id: 1,
      name: 'Áo phông trắng',
      category: 'Quần áo',
      imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=300&auto=format&fit=crop&q=80',
      description: 'Áo thun cotton basic mát mẻ phom suông rộng rãi.',
      brandId: 101,
      brandName: 'Zara',
    ),
    ClothingItem(
      id: 2,
      name: 'Quần Jeans xanh',
      category: 'Quần áo',
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=300&auto=format&fit=crop&q=80',
      description: 'Quần jean xanh denim phom dáng ôm vừa vặn.',
      brandId: 102,
      brandName: "Levi's",
    ),
    ClothingItem(
      id: 3,
      name: 'Chân váy chữ A',
      category: 'Quần áo',
      imageUrl: 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=300&auto=format&fit=crop&q=80',
      description: 'Chân váy năng động dáng ngắn tôn dáng.',
      brandId: 103,
      brandName: 'H&M',
    ),
    ClothingItem(
      id: 4,
      name: 'Áo khoác bomber xanh',
      category: 'Áo khoác',
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300&auto=format&fit=crop&q=80',
      description: 'Áo khoác bomber chống gió màu xanh rêu thời thượng.',
      brandId: 104,
      brandName: 'Uniqlo',
    ),
    ClothingItem(
      id: 5,
      name: 'Áo blazer đen',
      category: 'Áo khoác',
      imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=300&auto=format&fit=crop&q=80',
      description: 'Áo vest blazer thanh lịch cho các dịp công sở hay đi tiệc.',
      brandId: 105,
      brandName: 'Mango',
    ),
    ClothingItem(
      id: 6,
      name: 'Túi xách da nâu',
      category: 'Phụ kiện',
      imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=300&auto=format&fit=crop&q=80',
      description: 'Túi xách làm từ da thật cao cấp tiện lợi.',
      brandId: 106,
      brandName: 'Gucci',
    ),
    ClothingItem(
      id: 7,
      name: 'Kính râm đen',
      category: 'Phụ kiện',
      imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300&auto=format&fit=crop&q=80',
      description: 'Kính mát phân cực chống tia UV.',
      brandId: 107,
      brandName: 'Ray-Ban',
    ),
  ];

  void _onInitSession(InitSession event, Emitter<TryonState> emit) {
    emit(TryOnSelecting(
      originalImagePath: event.originalImagePath,
      activeCategory: 'Quần áo',
      availableItems: _mockGarments,
      selectedItems: const [],
    ));
  }

  void _onChangeCategory(ChangeCategory event, Emitter<TryonState> emit) {
    final currentState = state;
    if (currentState is TryOnSelecting) {
      emit(currentState.copyWith(activeCategory: event.category));
    }
  }

  void _onSelectClothing(SelectClothing event, Emitter<TryonState> emit) {
    final currentState = state;
    if (currentState is TryOnSelecting) {
      final currentSelected = List<ClothingItem>.from(currentState.selectedItems);

      // Check if already selected: remove it. Otherwise, select it.
      // Rule: allow only 1 item per sub-category/name or replace same category items if needed.
      // Let's just toggle the item selection for simplicity.
      if (currentSelected.any((e) => e.id == event.item.id)) {
        currentSelected.removeWhere((e) => e.id == event.item.id);
      } else {
        // Replace items of same ID or simply add it (max 1 per unique id)
        // Let's replace items of the exact same name or simply allow multiple.
        // Let's just add/remove.
        currentSelected.add(event.item);
      }

      emit(currentState.copyWith(selectedItems: currentSelected));
    }
  }

  void _onProcessTryOn(ProcessTryOn event, Emitter<TryonState> emit) async {
    final currentState = state;
    if (currentState is TryOnSelecting) {
      final originalImage = currentState.originalImagePath;
      final selected = currentState.selectedItems;

      emit(const TryOnGenerating());
      // Simulate AI processing delay of 1.5 seconds
      await Future.delayed(const Duration(milliseconds: 1500));

      // Decide on mock result image based on selection
      String resultImage = 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80'; // default
      if (selected.any((item) => item.id == 4)) {
        // Bomber jacket selected
        resultImage = 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&auto=format&fit=crop&q=80';
      } else if (selected.any((item) => item.id == 2)) {
        // Jeans selected
        resultImage = 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=600&auto=format&fit=crop&q=80';
      }

      final session = TryonSession(
        originalImagePath: originalImage,
        resultImagePath: resultImage,
        selectedItems: selected,
        fitScore: 92.0,
        styleCategory: 'Casual',
        harmonyCategory: 'Hài hòa',
      );

      emit(TryOnResultLoaded(
        session: session,
        showAfter: true, // Default to After (AI) view
      ));
    }
  }

  void _onToggleBeforeAfter(ToggleBeforeAfter event, Emitter<TryonState> emit) {
    final currentState = state;
    if (currentState is TryOnResultLoaded) {
      emit(currentState.copyWith(showAfter: event.showAfter));
    }
  }

  void _onConfirmOutfit(ConfirmOutfit event, Emitter<TryonState> emit) async {
    final currentState = state;
    if (currentState is TryOnResultLoaded || currentState is TryOnSelecting) {
      emit(const TryOnSuccess());
    }
  }
}
