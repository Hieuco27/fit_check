import 'package:equatable/equatable.dart';
import 'package:fit_check/features/capture/domain/entities/system_model.dart';

abstract class PortraitPickerState extends Equatable {
  const PortraitPickerState();

  @override
  List<Object?> get props => [];
}

/// Đang tải data
class PortraitPickerLoading extends PortraitPickerState {
  const PortraitPickerLoading();
}

/// Đã tải xong — hiển thị UI
class PortraitPickerLoaded extends PortraitPickerState {
  final int tabIndex;
  final List<SystemModel> systemModels;
  final List<String> photos; // Danh sách ảnh thư viện (URL mock)

  /// Đường dẫn ảnh đang được chọn (null = chưa chọn)
  final String? selectedImagePath;

  /// Model hệ thống đang được chọn (null = chưa chọn)
  final SystemModel? selectedModel;

  const PortraitPickerLoaded({
    this.tabIndex = 0,
    required this.systemModels,
    required this.photos,
    this.selectedImagePath,
    this.selectedModel,
  });

  PortraitPickerLoaded copyWith({
    int? tabIndex,
    List<SystemModel>? systemModels,
    List<String>? photos,
    String? selectedImagePath,
    SystemModel? selectedModel,
    bool clearSelection = false, // Dùng để clear cả 2 cùng lúc
  }) {
    return PortraitPickerLoaded(
      tabIndex: tabIndex ?? this.tabIndex,
      systemModels: systemModels ?? this.systemModels,
      photos: photos ?? this.photos,
      selectedImagePath:
          clearSelection ? null : selectedImagePath ?? this.selectedImagePath,
      selectedModel:
          clearSelection ? null : selectedModel ?? this.selectedModel,
    );
  }

  /// true nếu user đã chọn 1 ảnh nào đó (model hoặc thư viện)
  bool get hasSelection => selectedImagePath != null || selectedModel != null;

  /// Đường dẫn ảnh cuối cùng để truyền vào TryOn
  String? get resolvedPortraitPath =>
      selectedModel?.imageUrl ?? selectedImagePath;

  @override
  List<Object?> get props => [
        tabIndex,
        systemModels,
        photos,
        selectedImagePath,
        selectedModel,
      ];
}

/// Đã xác nhận lựa chọn → trigger navigate sang TryOnResult
class PortraitPickerConfirmed extends PortraitPickerState {
  final String portraitPath;
  const PortraitPickerConfirmed(this.portraitPath);

  @override
  List<Object?> get props => [portraitPath];
}
