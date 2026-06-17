import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/core/constants/app_colors.dart';
import 'package:fit_check/core/utils/text_styles.dart';

class UserAvatarCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String styleTitle;
  final String location;
  final VoidCallback? onEditAvatarTap;

  const UserAvatarCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.styleTitle,
    required this.location,
    this.onEditAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar circle with gradient border and edit badge
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Outer Gradient Border Container
              Container(
                width: 120.w,
                height: 120.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF00C6FF), // Neon Blue
                      Color(0xFF8E2DE2), // Purple
                      Color(0xFFF000FF), // Neon Pink
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.w), // Border thickness
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person, size: 50.sp, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Floating Edit Button Badge
              Positioned(
                bottom: 2.w,
                right: 2.w,
                child: GestureDetector(
                  onTap: onEditAvatarTap ?? () {},
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.brandPurple,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Name
        Text(
          name,
          style: AppTextStyles.titleLarge().copyWith(
            color: const Color(0xFF1F1B2C),
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        // Style Title & Location
        Text(
          '$styleTitle • $location',
          style: AppTextStyles.bodyMedium().copyWith(
            color: const Color(0xFF7D7690),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
