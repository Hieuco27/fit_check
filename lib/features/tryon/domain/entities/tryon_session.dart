import 'package:fit_check/features/tryon/domain/entities/clothing_item.dart';

class TryonSession {
  final String originalImagePath;
  final String? resultImagePath;
  final List<ClothingItem> selectedItems;
  final double fitScore;
  final String styleCategory;
  final String harmonyCategory;

  const TryonSession({
    required this.originalImagePath,
    this.resultImagePath,
    required this.selectedItems,
    required this.fitScore,
    required this.styleCategory,
    required this.harmonyCategory,
  });

  TryonSession copyWith({
    String? originalImagePath,
    String? resultImagePath,
    List<ClothingItem>? selectedItems,
    double? fitScore,
    String? styleCategory,
    String? harmonyCategory,
  }) {
    return TryonSession(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      resultImagePath: resultImagePath ?? this.resultImagePath,
      selectedItems: selectedItems ?? this.selectedItems,
      fitScore: fitScore ?? this.fitScore,
      styleCategory: styleCategory ?? this.styleCategory,
      harmonyCategory: harmonyCategory ?? this.harmonyCategory,
    );
  }
}
