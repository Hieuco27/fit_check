import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';
import 'package:fit_check/features/capture/domain/repositories/capture_repository.dart';

/// Use Case: Gửi ảnh quần áo để AI phân tích + tách nền
/// Output: GarmentScan (loại đồ, màu, kiểu dáng, tags, removedBgImagePath)
/// → Sẽ so khớp với bảng garments khi có BE
class AnalyzeGarmentUseCase {
  final CaptureRepository _repository;

  const AnalyzeGarmentUseCase(this._repository);

  Future<GarmentScan> call(String imagePath) async {
    return _repository.analyzeGarment(imagePath);
  }
}
