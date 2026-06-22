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
    on<ToggleBeforeAfterEvent>(_onToggleBeforeAfter);
    on<SaveSessionEvent>(_onSaveSession);
    on<AddWishlistEvent>(_onAddWishlist);
    on<FindNearbyStoresEvent>(_onFindNearbyStores);
    // ── Legacy events ──
    on<ChangeCategory>(_onChangeCategory);
    on<SelectClothing>(_onSelectClothing);
    on<ToggleBeforeAfter>(_onToggleBeforeAfterLegacy);
    on<ConfirmOutfit>(_onConfirmOutfit);
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
      emit(
        TryOnResultLoaded(
          session: current.session.copyWith(saved: true),
          showAfter: current.showAfter,
          availableVariants: current.availableVariants,
        ),
      );
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
      emit(
        current.copyWith(session: current.session.copyWith(inWishlist: true)),
      );
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

  void _onToggleBeforeAfterLegacy(
    ToggleBeforeAfter event,
    Emitter<TryonState> emit,
  ) {
    final current = state;
    if (current is TryOnResultLoaded) {
      emit(current.copyWith(showAfter: event.showAfter));
    }
  }

  Future<void> _onConfirmOutfit(
    ConfirmOutfit event,
    Emitter<TryonState> emit,
  ) async {
    emit(const TryOnSuccess());
  }
}
