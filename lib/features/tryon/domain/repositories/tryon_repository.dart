import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';
import 'package:fit_check/features/tryon/domain/entities/store_location.dart';
import 'package:fit_check/features/tryon/domain/entities/tryon_session.dart';

/// Abstract repository contract cho feature tryon.
/// Mỗi method có TODO comment để team BE gán vào sau.
abstract class TryonRepository {
  /// Submit ảnh người + ảnh quần áo → AI xử lý → trả về result_image_url
  /// TODO: POST /api/tryon/submit
  Future<TryonSession> submitTryOn({
    required String portraitImagePath,
    required String garmentImagePath,
    required GarmentVariant variant,
  });

  /// Lưu phiên thử đồ (saved = true trong bảng tryon_sessions)
  /// TODO: PATCH /api/tryon/sessions/{id}/save
  Future<void> saveSession(String sessionId);

  /// Thêm vào wishlist (bảng wishlists)
  /// TODO: POST /api/wishlists
  Future<void> addToWishlist({required int garmentId, required int userId});

  /// Tìm cửa hàng gần nhất theo lat/lng + variant
  /// TODO: GET /api/stores/nearby?lat=&lng=&variant_id=&size=
  Future<List<StoreLocation>> findNearbyStores({
    required double latitude,
    required double longitude,
    required int variantId,
    required String size,
  });
}
