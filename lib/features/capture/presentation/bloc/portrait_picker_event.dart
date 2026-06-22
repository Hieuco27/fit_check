import 'package:equatable/equatable.dart';
import 'package:fit_check/features/capture/domain/entities/system_model.dart';

abstract class PortraitPickerEvent extends Equatable {
  const PortraitPickerEvent();

  @override
  List<Object?> get props => [];
}

/// Tải data ban đầu (model + ảnh thư viện mock)
class LoadPickerData extends PortraitPickerEvent {
  const LoadPickerData();
}

/// Chuyển tab: 0=Tất cả, 1=Ưa thích, 2=Selfie, 3=Chân dung
class SwitchPickerTab extends PortraitPickerEvent {
  final int tabIndex;
  const SwitchPickerTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

/// Chọn model hệ thống
class SelectSystemModel extends PortraitPickerEvent {
  final SystemModel model;
  const SelectSystemModel(this.model);

  @override
  List<Object?> get props => [model];
}

/// Chọn ảnh từ thư viện (đường dẫn ảnh local hoặc URL)
class SelectPhoto extends PortraitPickerEvent {
  final String imagePath;
  const SelectPhoto(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// Mở camera để chụp selfie mới
class OpenSelfieCamera extends PortraitPickerEvent {
  const OpenSelfieCamera();
}

/// Xác nhận lựa chọn và tiến hành try-on
class ConfirmPortraitSelection extends PortraitPickerEvent {
  const ConfirmPortraitSelection();
}
