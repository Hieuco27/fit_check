import 'package:equatable/equatable.dart';
import 'package:fit_check/features/tryon/domain/entities/clothing_item.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';
import 'package:fit_check/features/tryon/domain/entities/store_location.dart';
import 'package:fit_check/features/tryon/domain/entities/tryon_session.dart';

abstract class TryonState extends Equatable {
  const TryonState();

  @override
  List<Object?> get props => [];
}

/// Khởi đầu
class TryonInitial extends TryonState {
  const TryonInitial();
}

/// Kết quả try-on đã load xong
class TryOnResultLoaded extends TryonState {
  final TryonSession session;
  final bool showAfter; // true = xem kết quả AI, false = ảnh gốc
  final List<GarmentVariant> availableVariants;

  const TryOnResultLoaded({
    required this.session,
    this.showAfter = true,
    this.availableVariants = const [],
  });

  TryOnResultLoaded copyWith({
    TryonSession? session,
    bool? showAfter,
    List<GarmentVariant>? availableVariants,
  }) {
    return TryOnResultLoaded(
      session: session ?? this.session,
      showAfter: showAfter ?? this.showAfter,
      availableVariants: availableVariants ?? this.availableVariants,
    );
  }

  @override
  List<Object?> get props => [session, showAfter, availableVariants];
}

/// Đang re-render do đổi variant (size/màu)
class TryOnRendering extends TryonState {
  final TryonSession previousSession;
  final GarmentVariant newVariant;

  const TryOnRendering({
    required this.previousSession,
    required this.newVariant,
  });

  @override
  List<Object?> get props => [previousSession, newVariant];
}

/// Đang lưu session
class TryOnSaving extends TryonState {
  final TryonSession session;
  const TryOnSaving(this.session);

  @override
  List<Object?> get props => [session];
}

/// Đang tải danh sách cửa hàng gần nhất
class StoresLoading extends TryonState {
  final TryonSession session;
  const StoresLoading(this.session);

  @override
  List<Object?> get props => [session];
}

/// Danh sách cửa hàng gần nhất đã load
class StoresLoaded extends TryonState {
  final TryonSession session;
  final List<StoreLocation> stores;

  const StoresLoaded({required this.session, required this.stores});

  @override
  List<Object?> get props => [session, stores];
}

/// Thành công
class TryOnSuccess extends TryonState {
  const TryOnSuccess();
}

/// Lỗi
class TryOnError extends TryonState {
  final String message;
  const TryOnError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Legacy states (giữ để backward compat) ──────────────────────────────────

class TryOnSelecting extends TryonState {
  final String originalImagePath;
  final String activeCategory;
  final List<ClothingItem> availableItems;
  final List<ClothingItem> selectedItems;

  const TryOnSelecting({
    required this.originalImagePath,
    required this.activeCategory,
    required this.availableItems,
    required this.selectedItems,
  });

  TryOnSelecting copyWith({
    String? originalImagePath,
    String? activeCategory,
    List<ClothingItem>? availableItems,
    List<ClothingItem>? selectedItems,
  }) {
    return TryOnSelecting(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      activeCategory: activeCategory ?? this.activeCategory,
      availableItems: availableItems ?? this.availableItems,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }

  @override
  List<Object?> get props => [
    originalImagePath,
    activeCategory,
    availableItems,
    selectedItems,
  ];
}

class TryOnGenerating extends TryonState {
  const TryOnGenerating();
}
