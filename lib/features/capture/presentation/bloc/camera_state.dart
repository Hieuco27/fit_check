import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_check/features/capture/domain/entities/body_profile.dart';
import 'package:fit_check/features/capture/domain/entities/captured_image.dart';
import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái khởi đầu
class CameraInitial extends CameraState {
  const CameraInitial();
}

/// Camera đang được khởi tạo
class CameraInitializing extends CameraState {
  const CameraInitializing();
}

/// Camera sẵn sàng — live preview đang chạy
class CameraReady extends CameraState {
  final CameraController controller;
  final CameraMode mode;
  final bool isFlashOn;
  final bool isFrontCamera;

  const CameraReady({
    required this.controller,
    required this.mode,
    this.isFlashOn = false,
    this.isFrontCamera = false,
  });

  CameraReady copyWith({
    CameraController? controller,
    CameraMode? mode,
    bool? isFlashOn,
    bool? isFrontCamera,
  }) {
    return CameraReady(
      controller: controller ?? this.controller,
      mode: mode ?? this.mode,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
    );
  }

  @override
  List<Object?> get props => [mode, isFlashOn, isFrontCamera];
}

/// Đang chụp ảnh (spinner nhỏ)
class CameraCapturing extends CameraState {
  final CameraMode mode;
  const CameraCapturing(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Đã chụp ảnh xong, đang chờ phân tích AI
class CapturePreview extends CameraState {
  final String imagePath;
  final CameraMode mode;

  const CapturePreview({required this.imagePath, required this.mode});

  @override
  List<Object?> get props => [imagePath, mode];
}

/// AI đang phân tích ảnh chân dung
class PortraitAnalyzing extends CameraState {
  final String imagePath;
  const PortraitAnalyzing(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// AI phân tích chân dung thành công → hiển thị hotspots
class PortraitAnalyzed extends CameraState {
  final String imagePath;
  final BodyProfile bodyProfile;
  final BodyZone? selectedZone;

  const PortraitAnalyzed({
    required this.imagePath,
    required this.bodyProfile,
    this.selectedZone,
  });

  PortraitAnalyzed copyWith({BodyZone? selectedZone}) {
    return PortraitAnalyzed(
      imagePath: imagePath,
      bodyProfile: bodyProfile,
      selectedZone: selectedZone,
    );
  }

  @override
  List<Object?> get props => [imagePath, bodyProfile, selectedZone];
}

/// AI đang phân tích ảnh quần áo
class GarmentAnalyzing extends CameraState {
  final String imagePath;
  const GarmentAnalyzing(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// AI phân tích quần áo thành công → hiển thị info + tách nền
class GarmentAnalyzed extends CameraState {
  final GarmentScan garmentScan;

  const GarmentAnalyzed({required this.garmentScan});

  @override
  List<Object?> get props => [garmentScan];
}

/// Lỗi camera hoặc AI
class CameraError extends CameraState {
  final String message;
  const CameraError(this.message);

  @override
  List<Object?> get props => [message];
}
