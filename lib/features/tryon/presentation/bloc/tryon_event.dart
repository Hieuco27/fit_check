import 'package:equatable/equatable.dart';
import 'package:fit_check/features/tryon/domain/entities/clothing_item.dart';

abstract class TryonEvent extends Equatable {
  const TryonEvent();

  @override
  List<Object?> get props => [];
}

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
  final ClothingItem item;

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
