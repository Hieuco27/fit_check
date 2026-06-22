import 'package:equatable/equatable.dart';

/// Entity cửa hàng gần nhất — map với bảng stores + store_inventory trong DB
class StoreLocation extends Equatable {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceKm;  // Khoảng cách tính toán từ vị trí user
  final int stockCount;
  final double price;
  final String size;


  const StoreLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.stockCount,
    required this.price,
    required this.size,
  });

  bool get inStock => stockCount > 0;

  @override
  List<Object?> get props => [id, name, latitude, longitude];
}
