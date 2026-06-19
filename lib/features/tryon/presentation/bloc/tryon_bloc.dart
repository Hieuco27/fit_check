import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_check/features/tryon/data/repositories/tryon_repository_impl.dart';
import 'package:fit_check/features/tryon/domain/entities/clothing_item.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';
import 'package:fit_check/features/tryon/domain/entities/tryon_session.dart';
import 'package:fit_check/features/tryon/domain/repositories/tryon_repository.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_event.dart';
import 'package:fit_check/features/tryon/presentation/bloc/tryon_state.dart';

/// TryonBloc — quản lý luồng Màn Hình 3: kết quả thử đồ ảo.
/// Xử lý: submit, variant change, save, wishlist, find stores.
class TryonBloc extends Bloc<TryonEvent, TryonState> {
  final TryonRepository _repository;

  TryonBloc({TryonRepository? repository})
      : _repository = repository ?? TryonRepositoryImpl(),
        super(const TryonInitial()) {
    // ── Events mới ──
    on<SubmitTryOnEvent>(_onSubmitTryOn);
    on<ChangeVariantEvent>(_onChangeVariant);
    on<ToggleBeforeAfterEvent>(_onToggleBeforeAfter);
    on<SaveSessionEvent>(_onSaveSession);
    on<AddWishlistEvent>(_onAddWishlist);
    on<FindNearbyStoresEvent>(_onFindNearbyStores);
    // ── Legacy events ──
    on<InitSession>(_onInitSession);
    on<ChangeCategory>(_onChangeCategory);
    on<SelectClothing>(_onSelectClothing);
    on<ProcessTryOn>(_onProcessTryOn);
    on<ToggleBeforeAfter>(_onToggleBeforeAfterLegacy);
    on<ConfirmOutfit>(_onConfirmOutfit);
  }

  // Mock list garments cho legacy flow
  final List<ClothingItem> _mockGarments = const [
    ClothingItem(
      id: 1,
      name: 'Áo phông trắng',
      category: 'Quần áo',
      imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=300&auto=format&fit=crop&q=80',
      description: 'Áo thun cotton basic mát mẻ phom suông rộng rãi.',
      brandId: 101,
      brandName: 'Zara',
      variants: [
        GarmentVariant(id: 1, size: 'S', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 5),
        GarmentVariant(id: 2, size: 'M', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 10),
        GarmentVariant(id: 3, size: 'L', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 3),
        GarmentVariant(id: 4, size: 'XL', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 0),
        GarmentVariant(id: 5, size: 'S', colorHex: '1A1A1A', colorName: 'Đen', price: 299000, stockCount: 7),
        GarmentVariant(id: 6, size: 'M', colorHex: '1A1A1A', colorName: 'Đen', price: 299000, stockCount: 8),
      ],
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

  // ─── Submit TryOn (Màn Hình 3 - luồng mới) ──────────────────────────────────
  Future<void> _onSubmitTryOn(
    SubmitTryOnEvent event,
    Emitter<TryonState> emit,
  ) async {
    // Bước 1: Emit processing với checklist animation
    emit(const TryOnProcessing(currentStepIndex: 0));
    await Future.delayed(const Duration(milliseconds: 800));

    emit(const TryOnProcessing(currentStepIndex: 1));
    await Future.delayed(const Duration(milliseconds: 700));

    emit(const TryOnProcessing(currentStepIndex: 2));
    await Future.delayed(const Duration(milliseconds: 800));

    emit(const TryOnProcessing(currentStepIndex: 3));

    try {
      // Gọi repository (mock hiện tại, swap API sau)
      final session = await _repository.submitTryOn(
        portraitImagePath: event.portraitImagePath,
        garmentImagePath: event.garmentImagePath,
        variant: event.initialVariant,
      );

      final variants = TryonRepositoryImpl.getMockVariants();

      emit(TryOnResultLoaded(
        session: session,
        showAfter: true,
        availableVariants: variants,
      ));
    } catch (e) {
      emit(TryOnError('Thử đồ thất bại: ${e.toString()}'));
    }
  }

  // ─── Change Variant (re-render ảnh) ──────────────────────────────────────────
  Future<void> _onChangeVariant(
    ChangeVariantEvent event,
    Emitter<TryonState> emit,
  ) async {
    final current = state;
    if (current is! TryOnResultLoaded) return;

    // Emit rendering state để show mini-spinner trên ảnh
    emit(TryOnRendering(
      previousSession: current.session,
      newVariant: event.variant,
    ));

    // Giả lập re-render (BE sẽ xử lý render với variant mới)
    await Future.delayed(const Duration(seconds: 1));

    // Cập nhật session với variant mới
    final updatedSession = current.session.copyWith(
      selectedVariant: event.variant,
      // Fit rating thay đổi theo size (mock logic)
      fitRating: _calculateFitRating(event.variant.size),
    );

    emit(TryOnResultLoaded(
      session: updatedSession,
      showAfter: current.showAfter,
      availableVariants: current.availableVariants,
    ));
  }

  // Mock: tính fit rating dựa trên size (sau này AI sẽ xử lý)
  FitRating _calculateFitRating(String size) {
    switch (size) {
      case 'XS':
      case 'S':
        return FitRating.tight;
      case 'M':
      case 'L':
        return FitRating.trueToSize;
      case 'XL':
      case 'XXL':
        return FitRating.loose;
      default:
        return FitRating.unknown;
    }
  }

  // ─── Toggle Before/After ──────────────────────────────────────────────────────
  void _onToggleBeforeAfter(
    ToggleBeforeAfterEvent event,
    Emitter<TryonState> emit,
  ) {
    final current = state;
    if (current is TryOnResultLoaded) {
      // Chỉ rebuild showAfter flag, không rebuild toàn bộ session
      emit(current.copyWith(showAfter: event.showAfter));
    }
  }

  // ─── Save Session ─────────────────────────────────────────────────────────────
  Future<void> _onSaveSession(
    SaveSessionEvent event,
    Emitter<TryonState> emit,
  ) async {
    final current = state;
    if (current is! TryOnResultLoaded) return;

    emit(TryOnSaving(current.session));

    try {
      await _repository.saveSession('mock-session-id');
      // Cập nhật saved = true trong session
      emit(TryOnResultLoaded(
        session: current.session.copyWith(saved: true),
        showAfter: current.showAfter,
        availableVariants: current.availableVariants,
      ));
    } catch (e) {
      // Khôi phục state cũ khi lỗi
      emit(current);
    }
  }

  // ─── Add Wishlist ─────────────────────────────────────────────────────────────
  Future<void> _onAddWishlist(
    AddWishlistEvent event,
    Emitter<TryonState> emit,
  ) async {
    final current = state;
    if (current is! TryOnResultLoaded) return;

    try {
      await _repository.addToWishlist(garmentId: 1, userId: 1);
      emit(current.copyWith(
        session: current.session.copyWith(inWishlist: true),
      ));
    } catch (_) {
      // Silent fail — toast được show ở View layer
    }
  }

  // ─── Find Nearby Stores ───────────────────────────────────────────────────────
  Future<void> _onFindNearbyStores(
    FindNearbyStoresEvent event,
    Emitter<TryonState> emit,
  ) async {
    final current = state;
    if (current is! TryOnResultLoaded) return;

    emit(StoresLoading(current.session));

    try {
      final stores = await _repository.findNearbyStores(
        // Mock location: TP.HCM Q1
        latitude: 10.7769,
        longitude: 106.7009,
        variantId: current.session.selectedVariant?.id ?? 1,
        size: current.session.selectedVariant?.size ?? 'M',
      );
      emit(StoresLoaded(session: current.session, stores: stores));
    } catch (e) {
      emit(TryOnError('Không tìm được cửa hàng: ${e.toString()}'));
    }
  }

  // ─── Legacy Handlers (giữ nguyên để backward compat) ────────────────────────
  void _onInitSession(InitSession event, Emitter<TryonState> emit) {
    emit(TryOnSelecting(
      originalImagePath: event.originalImagePath,
      activeCategory: 'Quần áo',
      availableItems: _mockGarments,
      selectedItems: const [],
    ));
  }

  void _onChangeCategory(ChangeCategory event, Emitter<TryonState> emit) {
    final current = state;
    if (current is TryOnSelecting) {
      emit(current.copyWith(activeCategory: event.category));
    }
  }

  void _onSelectClothing(SelectClothing event, Emitter<TryonState> emit) {
    final current = state;
    if (current is TryOnSelecting) {
      final items = List<ClothingItem>.from(current.selectedItems);
      final item = event.item as ClothingItem;
      if (items.any((e) => e.id == item.id)) {
        items.removeWhere((e) => e.id == item.id);
      } else {
        items.add(item);
      }
      emit(current.copyWith(selectedItems: items));
    }
  }

  Future<void> _onProcessTryOn(ProcessTryOn event, Emitter<TryonState> emit) async {
    final current = state;
    if (current is TryOnSelecting) {
      emit(const TryOnGenerating());
      await Future.delayed(const Duration(milliseconds: 1500));
      final session = TryonSession(
        originalImagePath: current.originalImagePath,
        resultImagePath: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
        selectedItems: current.selectedItems,
        fitScore: 92.0,
        styleCategory: 'Casual',
        harmonyCategory: 'Hài hòa',
        fitRating: FitRating.trueToSize,
      );
      emit(TryOnResultLoaded(
        session: session,
        showAfter: true,
        availableVariants: TryonRepositoryImpl.getMockVariants(),
      ));
    }
  }

  void _onToggleBeforeAfterLegacy(ToggleBeforeAfter event, Emitter<TryonState> emit) {
    final current = state;
    if (current is TryOnResultLoaded) {
      emit(current.copyWith(showAfter: event.showAfter));
    }
  }

  Future<void> _onConfirmOutfit(ConfirmOutfit event, Emitter<TryonState> emit) async {
    emit(const TryOnSuccess());
  }
}
