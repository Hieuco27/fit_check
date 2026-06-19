import 'package:equatable/equatable.dart';
import 'package:fit_check/features/capture/domain/entities/body_profile.dart';
import 'package:fit_check/features/tryon/domain/entities/clothing_item.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';

/// Mức độ vừa vặn của trang phục (AI Fit Rating)
/// Map với trường fit_rating trong bảng tryon_sessions
enum FitRating {
  trueToSize, // Vừa vặn → màu xanh lá
  tight,      // Quá chật → màu đỏ
  loose,      // Quá rộng → màu cam
  unknown,    // Chưa xác định
}

/// Entity phiên thử đồ — map với bảng tryon_sessions trong DB
class TryonSession extends Equatable {
  final String originalImagePath;       // Ảnh gốc người dùng
  final String? garmentImagePath;       // Ảnh quần áo (nếu garment mode)
  final String? resultImagePath;        // result_image_url từ AI
  final List<ClothingItem> selectedItems;
  final double fitScore;                // Điểm tổng hợp (0-100)
  final String styleCategory;
  final String harmonyCategory;
  // Trường mới
  final FitRating fitRating;            // AI Fit Rating Badge
  final BodyZone? targetBodyZone;       // Vùng cơ thể đang thử (từ hotspot tap)
  final GarmentVariant? selectedVariant; // Biến thể đang chọn
  final bool saved;                     // Đã lưu vào tryon_sessions chưa
  final bool inWishlist;                // Đã thêm vào wishlists chưa

  const TryonSession({
    required this.originalImagePath,
    this.garmentImagePath,
    this.resultImagePath,
    required this.selectedItems,
    required this.fitScore,
    required this.styleCategory,
    required this.harmonyCategory,
    this.fitRating = FitRating.unknown,
    this.targetBodyZone,
    this.selectedVariant,
    this.saved = false,
    this.inWishlist = false,
  });

  TryonSession copyWith({
    String? originalImagePath,
    String? garmentImagePath,
    String? resultImagePath,
    List<ClothingItem>? selectedItems,
    double? fitScore,
    String? styleCategory,
    String? harmonyCategory,
    FitRating? fitRating,
    BodyZone? targetBodyZone,
    GarmentVariant? selectedVariant,
    bool? saved,
    bool? inWishlist,
  }) {
    return TryonSession(
      originalImagePath: originalImagePath ?? this.originalImagePath,
      garmentImagePath: garmentImagePath ?? this.garmentImagePath,
      resultImagePath: resultImagePath ?? this.resultImagePath,
      selectedItems: selectedItems ?? this.selectedItems,
      fitScore: fitScore ?? this.fitScore,
      styleCategory: styleCategory ?? this.styleCategory,
      harmonyCategory: harmonyCategory ?? this.harmonyCategory,
      fitRating: fitRating ?? this.fitRating,
      targetBodyZone: targetBodyZone ?? this.targetBodyZone,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      saved: saved ?? this.saved,
      inWishlist: inWishlist ?? this.inWishlist,
    );
  }

  @override
  List<Object?> get props => [
    originalImagePath,
    resultImagePath,
    selectedItems,
    fitScore,
    fitRating,
    selectedVariant,
    saved,
    inWishlist,
  ];
}
