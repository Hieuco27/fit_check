import 'package:fit_check/features/capture/domain/entities/body_profile.dart';
import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';
import 'package:fit_check/features/capture/domain/repositories/capture_repository.dart';

/// MOCK implementation của CaptureRepository.
/// Giả lập độ trễ AI processing và trả về dữ liệu mock.
/// Khi có BE API: chỉ cần thay class này bằng CaptureRepositoryImpl thật,
/// domain layer và Bloc KHÔNG cần thay đổi.
class CaptureRepositoryImpl implements CaptureRepository {
  @override
  Future<BodyProfile> analyzePortrait(String imagePath) async {
    // Giả lập thời gian xử lý AI ~1.5 giây
    await Future.delayed(const Duration(milliseconds: 1500));

    // TODO: Thay bằng gọi API thật khi có BE
    // final response = await _remoteDataSource.analyzePortrait(imagePath);
    // return BodyProfileModel.fromJson(response).toEntity();

    // Mock: trả về body profile cố định với hotspots layout chuẩn
    return BodyProfile.mockDetected();
  }

  @override
  Future<GarmentScan> analyzeGarment(String imagePath) async {
    // Giả lập thời gian xử lý AI ~2 giây (tách nền phức tạp hơn)
    await Future.delayed(const Duration(milliseconds: 2000));

    // TODO: Thay bằng gọi API thật khi có BE
    // final response = await _remoteDataSource.analyzeGarment(imagePath);
    // return GarmentScanModel.fromJson(response).toEntity();

    // Mock: nhận diện thành công và trả về thông tin giả
    return GarmentScan.mockFromPath(imagePath);
  }
}
