import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GarmentSelectionPanel extends StatefulWidget {
  final String? selectedGarmentUrl;
  final Function(String garmentUrl) onGarmentSelected;

  const GarmentSelectionPanel({
    super.key,
    this.selectedGarmentUrl,
    required this.onGarmentSelected,
  });

  @override
  State<GarmentSelectionPanel> createState() => _GarmentSelectionPanelState();
}

class _GarmentSelectionPanelState extends State<GarmentSelectionPanel> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Có sẵn', 'Quần áo của bạn'];

  // Các chip danh mục phụ
  int _selectedChipIndex = 0;
  final List<Map<String, String>> _chips = [
    {'icon': '🌟', 'label': 'Phổ biến', 'count': '85'},
    {'icon': '❤️', 'label': 'Quốc gia', 'count': '133'},
    {'icon': '👗', 'label': 'Tiệc', 'count': '43'},
  ];

  // Giả lập ảnh (sử dụng một số ảnh chân dung nữ như trong hình thiết kế)
  final List<String> _mockGarments = [
    'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1620799140188-3b2a02fd9a77?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=300&auto=format&fit=crop&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF16181C), // Màu nền tối xanh rêu/xám đậm giống ảnh
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Text Trạng Thái (Có thể truyền từ ngoài vào, nhưng tạm để đây theo thiết kế) ──

          // ── Tab Bar (Có sẵn / Quần áo của bạn) ──────────────────────────
          _buildTabBar(),

          Divider(height: 1, color: Colors.white10),

          // ── Filter Chips ────────────────────────────────────────────────
          _buildFilterChips(),

          // ── Grid Layout ─────────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(
                16.w,
                8.h,
                16.w,
                100.h,
              ), // padding bottom lớn để tránh nút
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.w,
                childAspectRatio: 0.7, // Ảnh dài
              ),
              // Cộng 1 cho nút "+ Thêm"
              itemCount: _mockGarments.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAddButton();
                }
                return _buildGarmentItem(_mockGarments[index - 1]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: List.generate(_tabs.length, (index) {
        final isActive = _selectedTabIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive
                        ? const Color(0xFF4EEB95)
                        : Colors.transparent, // Màu gạch chân xanh mint
                    width: 2.5,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _tabs[index],
                style: GoogleFonts.inter(
                  color: isActive ? Colors.white : Colors.white54,
                  fontSize: 14.sp,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SizedBox(
        height: 32.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: _chips.length,
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            final chip = _chips[index];
            final isActive = _selectedChipIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedChipIndex = index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF262A34)
                      : const Color(0xFF1E2128),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Text(chip['icon']!, style: TextStyle(fontSize: 12.sp)),
                    SizedBox(width: 4.w),
                    Text(
                      chip['label']!,
                      style: GoogleFonts.inter(
                        color: isActive ? Colors.white : Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        chip['count']!,
                        style: GoogleFonts.inter(
                          color: Colors.white54,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F222A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.white70, size: 28.sp),
          SizedBox(height: 4.h),
          Text(
            'Thêm',
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGarmentItem(String imageUrl) {
    final isSelected = widget.selectedGarmentUrl == imageUrl;

    return GestureDetector(
      onTap: () => widget.onGarmentSelected(imageUrl),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF262A34),
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: const Color(0xFF4EEB95), width: 2)
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover, cacheHeight: 300),
            // Icon kim cương ở góc trái dưới như thiết kế
            Positioned(
              left: 6.w,
              bottom: 6.h,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.diamond_outlined,
                  color: const Color(0xFFA584FF),
                  size: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
