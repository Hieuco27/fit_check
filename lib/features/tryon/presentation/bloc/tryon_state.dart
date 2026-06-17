import 'package:equatable/equatable.dart';
import 'package:fit_check/features/tryon/domain/entities/clothing_item.dart';
import 'package:fit_check/features/tryon/domain/entities/tryon_session.dart';

abstract class TryonState extends Equatable {
  const TryonState();

  @override
  List<Object?> get props => [];
}

class TryonInitial extends TryonState {
  const TryonInitial();
}

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

class TryOnResultLoaded extends TryonState {
  final TryonSession session;
  final bool showAfter; // true for "After (AI)", false for "Before"

  const TryOnResultLoaded({
    required this.session,
    required this.showAfter,
  });

  TryOnResultLoaded copyWith({
    TryonSession? session,
    bool? showAfter,
  }) {
    return TryOnResultLoaded(
      session: session ?? this.session,
      showAfter: showAfter ?? this.showAfter,
    );
  }

  @override
  List<Object?> get props => [session, showAfter];
}

class TryOnSuccess extends TryonState {
  const TryOnSuccess();
}

class TryOnError extends TryonState {
  final String message;

  const TryOnError(this.message);

  @override
  List<Object?> get props => [message];
}
