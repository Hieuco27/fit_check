import 'package:fit_check/features/capture/domain/entities/body_profile.dart';
import 'package:fit_check/features/capture/domain/repositories/capture_repository.dart';

/// Use Case: Gửi ảnh chân dung để AI phân tích
/// Output: BodyProfile (body_shape, skin_tone, hotspots)
/// → Sẽ cập nhật bảng body_profiles khi có BE
class AnalyzePortraitUseCase {
  final CaptureRepository _repository;

  const AnalyzePortraitUseCase(this._repository);

  Future<BodyProfile> call(String imagePath) async {
    return _repository.analyzePortrait(imagePath);
  }
}
