import 'package:equatable/equatable.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';
import 'package:fit_check/features/capture/domain/entities/body_profile.dart';

abstract class TryonEvent extends Equatable {
  const TryonEvent();

  @override
  List<Object?> get props => [];
}

/// Bắt đầu phiên thử đồ mới với ảnh người và quần áo
class SubmitTryOnEvent extends TryonEvent {
  final String portraitImagePath;
  final String garmentImagePath;
  final GarmentVariant initialVariant;
  final BodyZone? targetZone;

  const SubmitTryOnEvent({
    required this.portraitImagePath,
    required this.garmentImagePath,
    required this.initialVariant,
    this.targetZone,
  });

  @override
  List<Object?> get props => [portraitImagePath, garmentImagePath, initialVariant];
}

/// Đổi biến thể (màu / size) → re-render ảnh try-on
class ChangeVariantEvent extends TryonEvent {
  final GarmentVariant variant;
  const ChangeVariantEvent(this.variant);

  @override
  List<Object?> get props => [variant];
}

/// Toggle Before/After view
class ToggleBeforeAfterEvent extends TryonEvent {
  final bool showAfter;
  const ToggleBeforeAfterEvent(this.showAfter);

  @override
  List<Object?> get props => [showAfter];
}

/// Lưu phiên thử đồ (saved = true trong tryon_sessions)
class SaveSessionEvent extends TryonEvent {
  const SaveSessionEvent();
}

/// Thêm vào wishlist
class AddWishlistEvent extends TryonEvent {
  const AddWishlistEvent();
}

/// Tìm cửa hàng gần nhất
class FindNearbyStoresEvent extends TryonEvent {
  const FindNearbyStoresEvent();
}

// ─── Legacy events (giữ để backward compat nếu cần) ─────────────────────────

class InitSession extends TryonEvent {
  final String originalImagePath;
  const InitSession(this.originalImagePath);

  @override
  List<Object?> get props => [originalImagePath];
}

class ChangeCategory extends TryonEvent {
  final String category;
  const ChangeCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SelectClothing extends TryonEvent {
  final dynamic item;
  const SelectClothing(this.item);

  @override
  List<Object?> get props => [item];
}

class ProcessTryOn extends TryonEvent {
  const ProcessTryOn();
}

class ToggleBeforeAfter extends TryonEvent {
  final bool showAfter;
  const ToggleBeforeAfter(this.showAfter);

  @override
  List<Object?> get props => [showAfter];
}

class ConfirmOutfit extends TryonEvent {
  const ConfirmOutfit();
}
