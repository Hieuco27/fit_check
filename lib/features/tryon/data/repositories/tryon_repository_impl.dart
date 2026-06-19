import 'package:fit_check/features/tryon/domain/entities/clothing_item.dart';
import 'package:fit_check/features/tryon/domain/entities/garment_variant.dart';
import 'package:fit_check/features/tryon/domain/entities/store_location.dart';
import 'package:fit_check/features/tryon/domain/entities/tryon_session.dart';
import 'package:fit_check/features/tryon/domain/repositories/tryon_repository.dart';

/// MOCK implementation của TryonRepository.
/// Toàn bộ giả lập bằng Future.delayed + dữ liệu tĩnh.
/// Khi BE ready: thay class này bằng TryonRepositoryImpl thật.
class TryonRepositoryImpl implements TryonRepository {
  // Mock garment variants — sẽ load từ API garment_variants thật sau
  static const List<GarmentVariant> _mockVariants = [
    GarmentVariant(id: 1, size: 'S', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 5),
    GarmentVariant(id: 2, size: 'M', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 10),
    GarmentVariant(id: 3, size: 'L', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 3),
    GarmentVariant(id: 4, size: 'XL', colorHex: 'FFFFFF', colorName: 'Trắng', price: 299000, stockCount: 0),
    GarmentVariant(id: 5, size: 'S', colorHex: '1A1A1A', colorName: 'Đen', price: 299000, stockCount: 7),
    GarmentVariant(id: 6, size: 'M', colorHex: '1A1A1A', colorName: 'Đen', price: 299000, stockCount: 8),
    GarmentVariant(id: 7, size: 'L', colorHex: '1A1A1A', colorName: 'Đen', price: 299000, stockCount: 2),
  ];

  // Mock stores — sẽ query từ stores + store_inventory thật sau
  static const List<StoreLocation> _mockStores = [
    StoreLocation(
      id: 1,
      name: 'Zara - Vincom Center',
      address: '72 Lê Thánh Tôn, Q1, TP.HCM',
      latitude: 10.7765,
      longitude: 106.7009,
      distanceKm: 0.8,
      stockCount: 5,
      price: 299000,
      size: 'M',
    ),
    StoreLocation(
      id: 2,
      name: 'Zara - Takashimaya',
      address: '65 Lê Lợi, Q1, TP.HCM',
      latitude: 10.7742,
      longitude: 106.6978,
      distanceKm: 1.2,
      stockCount: 3,
      price: 299000,
      size: 'M',
    ),
    StoreLocation(
      id: 3,
      name: 'Zara - Crescent Mall',
      address: '101 Tôn Dật Tiên, Q7, TP.HCM',
      latitude: 10.7300,
      longitude: 106.7200,
      distanceKm: 4.5,
      stockCount: 0,
      price: 299000,
      size: 'M',
    ),
  ];

  @override
  Future<TryonSession> submitTryOn({
    required String portraitImagePath,
    required String garmentImagePath,
    required GarmentVariant variant,
  }) async {
    // Giả lập thời gian AI xử lý 3-5 giây
    await Future.delayed(const Duration(seconds: 3));

    // TODO: Thay bằng API call thực khi có BE
    // final response = await _remote.submitTryOn(portrait, garment, variant);

    return TryonSession(
      originalImagePath: portraitImagePath,
      garmentImagePath: garmentImagePath,
      // Mock result — dùng chính ảnh quần áo như "kết quả" tạm thời
      resultImagePath: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
      selectedItems: const [
        ClothingItem(
          id: 1,
          name: 'Áo phông trắng',
          category: 'Quần áo',
          imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=300',
          description: '',
          brandId: 101,
          brandName: 'Zara',
          variants: _mockVariants,
        ),
      ],
      fitScore: 88.0,
      styleCategory: 'Casual',
      harmonyCategory: 'Hài hòa',
      fitRating: FitRating.trueToSize,
      selectedVariant: variant,
    );
  }

  @override
  Future<void> saveSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: PATCH /api/tryon/sessions/{sessionId}/save
  }

  @override
  Future<void> addToWishlist({required int garmentId, required int userId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: POST /api/wishlists { garment_id, user_id }
  }

  @override
  Future<List<StoreLocation>> findNearbyStores({
    required double latitude,
    required double longitude,
    required int variantId,
    required String size,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: GET /api/stores/nearby?lat=&lng=&variant_id=&size=
    // Filter mock theo size được chọn
    return _mockStores
        .where((store) => store.size == size)
        .toList();
  }

  /// Trả về danh sách variants mock cho một garment
  /// TODO: GET /api/garments/{id}/variants
  static List<GarmentVariant> getMockVariants() => _mockVariants;
}
