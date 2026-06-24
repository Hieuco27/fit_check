import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TryOnResultPage extends StatefulWidget {
  final String portraitImagePath;
  final String garmentImagePath;
  final String? resultImagePath;

  const TryOnResultPage({
    super.key,
    required this.portraitImagePath,
    required this.garmentImagePath,
    this.resultImagePath,
  });

  @override
  State<TryOnResultPage> createState() => _TryOnResultPageState();
}

class _TryOnResultPageState extends State<TryOnResultPage> {
  // true = Sau (AI), false = Trước (Original)
  bool _showAfter = true;
  // Trạng thái giữ (hold to compare)
  final bool _isHolding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // Nền sáng
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── Segmented Control (Trước / Sau) ──────────────────────────
            _buildSegmentedControl(),
            SizedBox(height: 16.h),

            // ── Image Area (60%) ──────────────────────────────────────────
            Expanded(child: _buildImageArea()),

            // ── Stats & Actions (40%) ─────────────────────────────────────
            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 90.w,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          padding: EdgeInsets.only(left: 16.w),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(Icons.arrow_back, color: Colors.black54, size: 18.sp),
              SizedBox(width: 4.w),
              Text(
                'Thử lại',
                style: GoogleFonts.inter(
                  color: Colors.black54,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      title: Text(
        'Kết quả ✨',
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Action Lưu
          },
          child: Container(
            padding: EdgeInsets.only(right: 16.w),
            alignment: Alignment.centerRight,
            child: Text(
              'Lưu',
              style: GoogleFonts.inter(
                color: Colors.black54,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Segmented Control ─────────────────────────────────────────────────────
  Widget _buildSegmentedControl() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showAfter = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: !_showAfter ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: !_showAfter
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Trước',
                  style: GoogleFonts.inter(
                    color: !_showAfter ? Colors.black : Colors.black45,
                    fontSize: 14.sp,
                    fontWeight: !_showAfter ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showAfter = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: _showAfter ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: _showAfter
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Sau (AI)',
                  style: GoogleFonts.inter(
                    color: _showAfter ? Colors.black : Colors.black45,
                    fontSize: 14.sp,
                    fontWeight: _showAfter ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Image Area ─────────────────────────────────────────────────────────────
  Widget _buildImageArea() {
    final currentImage = (_showAfter && !_isHolding)
        ? widget.resultImagePath ?? widget.garmentImagePath
        : widget.portraitImagePath;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2EE),
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Ảnh chính ──
          _buildImage(currentImage),

          // ── Badge AI (chỉ hiện trên ảnh Sau) ──
          if (_showAfter && !_isHolding)
            Positioned(
              top: 16.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFA584FF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'AI',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.person, color: Colors.black12, size: 100),
        ),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.person, color: Colors.black12, size: 100),
      ),
    );
  }

  // ─── Bottom Panel ───────────────────────────────────────────────────────────
  Widget _buildBottomPanel() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
      child: Column(
        children: [
          // ── Stats Row ──
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Độ vừa vặn',
                  value: '92%',
                  valueColor: const Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  title: 'Phong cách',
                  value: 'Casual',
                  valueColor: const Color(0xFFA584FF),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  title: 'Màu sắc',
                  value: 'Hài hòa',
                  valueColor: const Color(0xFFFF5A8C),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ── Tìm mua Button ──
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: () {
                // Action Tìm mua
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA584FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Tìm mua sản phẩm này',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // ── Đổi đồ & Chia sẻ ──
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.undo, color: Colors.black, size: 16.sp),
                        SizedBox(width: 6.w),
                        Text(
                          'Đổi đồ khác',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: OutlinedButton(
                    onPressed: () {
                      // Action Chia sẻ
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.ios_share, color: Colors.black, size: 16.sp),
                        SizedBox(width: 6.w),
                        Text(
                          'Chia sẻ',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        border: Border.all(color: const Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              color: valueColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.black45,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
