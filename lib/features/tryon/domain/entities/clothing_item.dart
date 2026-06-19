import 'package:equatable/equatable.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';

/// Entity sản phẩm quần áo — map với bảng garments trong DB
class ClothingItem extends Equatable {
  final int id;
  final String name;
  final String category;
  final String imageUrl;
  final String description;
  final int brandId;
  final String brandName;
  // Thêm variants để hỗ trợ Variant Picker ở Màn Hình 3
  final List<GarmentVariant> variants;

  const ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.brandId,
    required this.brandName,
    this.variants = const [],
  });

  @override
  List<Object?> get props => [id, name, category, brandId];
}
