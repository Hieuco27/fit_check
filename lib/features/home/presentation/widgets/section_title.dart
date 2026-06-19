import 'package:fit_check/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool showArrow;
  final VoidCallback? onArrowTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.showArrow = true,
    this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.bodyLarge1(color: Colors.white)),
          if (showArrow) ...[
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: onArrowTap,
              child: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
