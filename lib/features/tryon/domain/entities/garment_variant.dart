import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entity biến thể sản phẩm — map với bảng garment_variants trong DB
class GarmentVariant extends Equatable {
  final int id;
  final String size;       // "XS", "S", "M", "L", "XL", "XXL"
  final String colorHex;   // "#FFFFFF"
  final String colorName;  // "Trắng"
  final double price;
  final int stockCount;    // Tồn kho (0 = hết hàng)

  const GarmentVariant({
    required this.id,
    required this.size,
    required this.colorHex,
    required this.colorName,
    required this.price,
    required this.stockCount,
  });

  /// Màu từ hex string
  Color get color {
    final hex = colorHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  bool get inStock => stockCount > 0;

  @override
  List<Object?> get props => [id, size, colorHex, price, stockCount];
}
