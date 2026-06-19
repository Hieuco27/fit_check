import 'package:fit_check/features/capture/domain/entities/body_profile.dart';
import 'package:fit_check/features/capture/domain/entities/garment_scan.dart';

/// Abstract repository contract cho feature capture.
/// Data layer sẽ implement interface này.
/// BE AI sẽ gán vào [analyzePortrait] và [analyzeGarment] sau.
abstract class CaptureRepository {
  /// Phân tích ảnh chân dung → trả về BodyProfile
  /// MOCK: giả lập 1.5 giây delay
  Future<BodyProfile> analyzePortrait(String imagePath);

  /// Phân tích ảnh quần áo → trả về GarmentScan (bao gồm tách nền)
  /// MOCK: giả lập 1.5 giây delay
  Future<GarmentScan> analyzeGarment(String imagePath);
}
