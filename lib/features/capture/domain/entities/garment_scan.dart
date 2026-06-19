import 'package:equatable/equatable.dart';

/// Entity kết quả phân tích garment từ AI (MOCK — sẽ map với bảng garments)
class GarmentScan extends Equatable {
  final String imagePath;           // Đường dẫn ảnh gốc
  final String? removedBgImagePath; // Đường dẫn ảnh đã tách nền (mock: cùng ảnh)
  final String garmentType;         // Loại đồ: "Áo phông", "Quần jeans", etc.
  final String color;               // Màu: "Trắng / Trơn"
  final String style;               // Kiểu dáng: "Oversize, cổ tròn"
  final List<String> tags;          // Tags: ["Casual", "Mùa hè", "Unisex"]
  final bool isDetected;

  const GarmentScan({
    required this.imagePath,
    this.removedBgImagePath,
    required this.garmentType,
    required this.color,
    required this.style,
    required this.tags,
    required this.isDetected,
  });

  /// Mock khi chưa có BE AI
  factory GarmentScan.mockFromPath(String imagePath) => GarmentScan(
    imagePath: imagePath,
    removedBgImagePath: imagePath, // Mock: cùng ảnh gốc
    garmentType: 'Áo phông',
    color: 'Trắng / Trơn',
    style: 'Oversize, cổ tròn',
    tags: const ['Casual', 'Mùa hè', 'Unisex'],
    isDetected: true,
  );

  /// Mock khi AI không nhận diện được
  factory GarmentScan.notDetected(String imagePath) => GarmentScan(
    imagePath: imagePath,
    garmentType: 'Không xác định',
    color: 'Không xác định',
    style: 'Không xác định',
    tags: const [],
    isDetected: false,
  );

  GarmentScan copyWith({
    String? garmentType,
    String? color,
    String? style,
    List<String>? tags,
  }) {
    return GarmentScan(
      imagePath: imagePath,
      removedBgImagePath: removedBgImagePath,
      garmentType: garmentType ?? this.garmentType,
      color: color ?? this.color,
      style: style ?? this.style,
      tags: tags ?? this.tags,
      isDetected: isDetected,
    );
  }

  @override
  List<Object?> get props => [imagePath, garmentType, color, style, tags, isDetected];
}
