import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/tryon/domain/entities/store_location.dart';

/// Bottom sheet hiển thị danh sách cửa hàng gần nhất.
/// Dạng DraggableScrollableSheet để vuốt lên được.
class NearbyStoresSheet extends StatelessWidget {
  final List<StoreLocation> stores;
  final String size;

  const NearbyStoresSheet({
    super.key,
    required this.stores,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFF5A623), size: 20),
                    SizedBox(width: 8.w),
                    Text(
                      'Cửa hàng gần bạn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFF5A623).withOpacity(0.4)),
                      ),
                      child: Text(
                        'Size $size',
                        style: TextStyle(
                          color: const Color(0xFFF5A623),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12, height: 1),
              // List stores
              Expanded(
                child: stores.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        controller: controller,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount: stores.length,
                        separatorBuilder: (_, __) => const Divider(
                          color: Colors.white12,
                          height: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                        itemBuilder: (_, i) => _StoreCard(store: stores[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.store_mall_directory_outlined, color: Colors.white24, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            'Không có cửa hàng nào gần bạn\ncó sẵn size này',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final StoreLocation store;
  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        children: [
          // Store icon
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: store.inStock
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: store.inStock ? const Color(0xFF4CAF50).withOpacity(0.3) : Colors.white12,
              ),
            ),
            child: Icon(
              Icons.store_outlined,
              color: store.inStock ? const Color(0xFF4CAF50) : Colors.white24,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          // Store info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  store.address,
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    const Icon(Icons.near_me, color: Colors.white38, size: 12),
                    SizedBox(width: 4.w),
                    Text(
                      '${store.distanceKm.toStringAsFixed(1)} km',
                      style: TextStyle(color: Colors.white38, fontSize: 11.sp),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: store.inStock ? const Color(0xFF4CAF50) : Colors.red,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      store.inStock ? 'Còn hàng (${store.stockCount})' : 'Hết hàng',
                      style: TextStyle(
                        color: store.inStock ? const Color(0xFF4CAF50) : Colors.red,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Price + navigate
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_formatPrice(store.price)}đ',
                style: TextStyle(
                  color: const Color(0xFFF5A623),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: store.inStock ? () {} : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: store.inStock
                        ? const Color(0xFFF5A623)
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    store.inStock ? 'Chỉ đường' : 'Hết hàng',
                    style: TextStyle(
                      color: store.inStock ? Colors.black : Colors.white38,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    }
    final p = price.toInt();
    return p.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}
