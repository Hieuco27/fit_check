import 'package:equatable/equatable.dart';

/// Vùng cơ thể được nhận diện — dùng cho Hotspot UI
enum BodyZone {
  top,    // Vùng áo (upper body)
  bottom, // Vùng quần
  dress,  // Vùng váy (full body)
  outer,  // Áo khoác ngoài
}

/// Toạ độ hotspot trên màn hình (normalized 0.0–1.0)
/// BE AI sẽ cung cấp sau. Hiện tại dùng giá trị hardcoded.
class HotspotPoint extends Equatable {
  final BodyZone zone;
  final double x; // 0.0 = trái, 1.0 = phải
  final double y; // 0.0 = trên, 1.0 = dưới
  final String label;

  const HotspotPoint({
    required this.zone,
    required this.x,
    required this.y,
    required this.label,
  });

  @override
  List<Object?> get props => [zone, x, y];
}

/// Entity kết quả phân tích body từ AI (MOCK — sẽ map với bảng body_profiles)
class BodyProfile extends Equatable {
  final String? bodyShape;    // e.g., "hourglass", "rectangle", "pear"
  final String? skinTone;     // e.g., "warm", "cool", "neutral"
  final List<HotspotPoint> hotspots; // Các điểm nhận diện vùng cơ thể
  final bool isDetected;      // AI có nhận diện được người không

  const BodyProfile({
    this.bodyShape,
    this.skinTone,
    required this.hotspots,
    required this.isDetected,
  });

  /// Mock profile khi AI chưa detect được
  factory BodyProfile.notDetected() => const BodyProfile(
    hotspots: [],
    isDetected: false,
  );

  /// Mock profile với các hotspot cố định (hardcoded layout giai đoạn đầu)
  /// Toạ độ normalized: x, y tương đối với kích thước ảnh preview
  factory BodyProfile.mockDetected() => const BodyProfile(
    bodyShape: 'balanced',
    skinTone: 'warm',
    isDetected: true,
    hotspots: [
      HotspotPoint(zone: BodyZone.top, x: 0.5, y: 0.28, label: 'Vùng Áo'),
      HotspotPoint(zone: BodyZone.bottom, x: 0.5, y: 0.62, label: 'Vùng Quần'),
      HotspotPoint(zone: BodyZone.outer, x: 0.18, y: 0.30, label: 'Áo Khoác'),
    ],
  );

  @override
  List<Object?> get props => [bodyShape, skinTone, hotspots, isDetected];
}
