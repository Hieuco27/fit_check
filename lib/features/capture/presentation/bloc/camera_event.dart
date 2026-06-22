import 'package:equatable/equatable.dart';
import 'package:fit_check/features/capture/domain/entities/captured_image.dart';
import 'package:fit_check/features/capture/domain/entities/body_profile.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

/// Khởi tạo camera controller
class InitCameraEvent extends CameraEvent {
  final CameraMode initialMode;

  /// true → mở cam trước (portrait/selfie), false → mở cam sau (garment)
  final bool useFrontCamera;

  const InitCameraEvent({
    this.initialMode = CameraMode.portrait,
    this.useFrontCamera = false,
  });

  @override
  List<Object?> get props => [initialMode, useFrontCamera];
}

/// Gạt thanh slider chuyển chế độ (Portrait ↔ Garment)
class SwitchCameraModeEvent extends CameraEvent {
  final CameraMode mode;
  const SwitchCameraModeEvent(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Chụp ảnh từ live camera
class CapturePhotoEvent extends CameraEvent {
  const CapturePhotoEvent();
}

/// Chọn ảnh từ gallery (image picker)
class PickFromGalleryEvent extends CameraEvent {
  const PickFromGalleryEvent();
}

/// Lật camera trước/sau
class FlipCameraEvent extends CameraEvent {
  const FlipCameraEvent();
}

/// Bật/tắt flash
class ToggleFlashEvent extends CameraEvent {
  const ToggleFlashEvent();
}

/// Phân tích ảnh chân dung sau khi chụp
class AnalyzePortraitEvent extends CameraEvent {
  final String imagePath;
  const AnalyzePortraitEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// Phân tích ảnh quần áo sau khi chụp
class AnalyzeGarmentEvent extends CameraEvent {
  final String imagePath;
  const AnalyzeGarmentEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// Chụp lại từ đầu
class RetakeCaptureEvent extends CameraEvent {
  const RetakeCaptureEvent();
}

/// Người dùng xác nhận ảnh chân dung ("Dùng ảnh này →")
class ConfirmPortraitEvent extends CameraEvent {
  const ConfirmPortraitEvent();
}

/// Người dùng xác nhận ảnh quần áo ("Thử đồ ngay")
class ConfirmGarmentEvent extends CameraEvent {
  const ConfirmGarmentEvent();
}

/// Người dùng tap vào Hotspot để chọn vùng cơ thể
class SelectBodyZoneEvent extends CameraEvent {
  final BodyZone zone;
  const SelectBodyZoneEvent(this.zone);

  @override
  List<Object?> get props => [zone];
}
