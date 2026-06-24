import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/features/closet/presentation/widgets/category_chips.dart';
import 'package:fit_check/features/closet/presentation/widgets/closet_search_bar.dart';
import 'package:fit_check/features/closet/presentation/widgets/custom_gradient_tabbar.dart';
import 'package:fit_check/features/closet/presentation/widgets/garment_grid_card.dart';

class ClosetPage extends StatefulWidget {
  const ClosetPage({super.key});

  @override
  State<ClosetPage> createState() => _ClosetPageState();
}

class _ClosetPageState extends State<ClosetPage> {
  int _activeTabIndex = 0;
  String _activeCategory = 'Tất cả';

  final List<String> _categories = [
    'Tất cả',
    'Áo',
    'Quần',
    'Váy',
    'Giày',
    'Phụ kiện',
  ];

  // Dummy mock data for UI
  final List<Map<String, dynamic>> _mockGarments = [
    {
      // T-shirt
      'image':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&q=80',
      'isNew': true,
    },
    {
      // Jacket
      'image':
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400&q=80',
      'isNew': false,
    },
    {
      // Dress
      'image':
          'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&q=80',
      'isNew': true,
    },
    {
      // Jeans
      'image':
          'https://images.unsplash.com/photo-1542272604-780c8d52a5ce?w=400&q=80',
      'isNew': false,
    },
    {
      // Shoes
      'image':
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&q=80',
      'isNew': false,
    },
    {
      // Bag/Accessory
      'image':
          'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?w=400&q=80',
      'isNew': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP SEARCH BAR
            ClosetSearchBar(
              onFilterTap: () {
                // TODO: Show filter modal
              },
            ),

            // 2. MAIN TABBAR
            CustomGradientTabBar(
              activeIndex: _activeTabIndex,
              onTabChanged: (index) {
                setState(() {
                  _activeTabIndex = index;
                });
              },
            ),
            SizedBox(height: 16.h),

            // 3. SUB-CATEGORY CHIPS
            CategoryChips(
              categories: _categories,
              activeCategory: _activeCategory,
              onCategorySelected: (category) {
                setState(() {
                  _activeCategory = category;
                });
              },
            ),
            SizedBox(height: 16.h),

            // 4. GARMENT GRIDVIEW
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3-column grid
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.85, // Adjust for portrait rectangle look
                ),
                itemCount:
                    _mockGarments.length *
                    3, // Just repeating the list for testing scroll
                itemBuilder: (context, index) {
                  final garment = _mockGarments[index % _mockGarments.length];
                  return GarmentGridCard(
                    imageUrl: garment['image'],
                    isNew: garment['isNew'],
                    onTryOnTap: () {
                      // TODO: Quick Try-On
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // 5. FLOATING ACTION BUTTON (FAB)
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: 60.h,
        ), // Push above the custom Home Nav Bar
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.homeAccentLight, AppColors.homeAccentBrown],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.homeAccentBrown.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              // TODO: Snap or upload photo
            },
            backgroundColor: Colors.transparent, // Let container gradient show
            elevation: 0, // Handled by container
            shape: const CircleBorder(),
            child: Icon(Icons.add_rounded, color: Colors.white, size: 32.sp),
          ),
        ),
      ),
    );
  }
}
