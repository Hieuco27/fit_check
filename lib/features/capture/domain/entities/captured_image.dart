import 'package:equatable/equatable.dart';

/// Chế độ chụp ảnh
enum CameraMode {
  portrait, // Chụp mẫu người (Portrait Try-On)
  garment,  // Chụp trang phục riêng lẻ (Flat Lay / Garment Scan)
}

/// Entity đại diện cho một ảnh đã được chụp hoặc chọn từ gallery
class CapturedImage extends Equatable {
  final String imagePath;
  final CameraMode mode;
  final DateTime capturedAt;

  const CapturedImage({
    required this.imagePath,
    required this.mode,
    required this.capturedAt,
  });

  @override
  List<Object?> get props => [imagePath, mode, capturedAt];
}
