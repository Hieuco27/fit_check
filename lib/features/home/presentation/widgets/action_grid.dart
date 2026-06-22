import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/home/domain/entities/home_action.dart';
import 'package:fit_check/features/home/presentation/widgets/action_card.dart';

/// Lưới 2×2 hiển thị 4 hành động chính tại trang Home.
/// Card đầu tiên (index 0) được đánh dấu [isPrimary] để hiển thị nổi bật hơn.
class ActionGrid extends StatelessWidget {
  final List<HomeAction> actions;
  final Function(int) onActionTap;

  const ActionGrid({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.length < 4) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            // Card 0 — Primary (nâu đậm, to hơn, có pulse glow)
            Expanded(
              child: SizedBox(
                height: 130.h,
                child: ActionCard(
                  action: actions[0],
                  onTap: () => onActionTap(0),
                  isPrimary: true, // Kích hoạt pulse glow animation
                ),
              ),
            ),
            SizedBox(width: 14.w),
            // Card 1 — Secondary
            Expanded(
              child: SizedBox(
                height: 130.h,
                child: ActionCard(
                  action: actions[1],
                  onTap: () => onActionTap(1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            // Card 2 — Secondary
            Expanded(
              child: SizedBox(
                height: 130.h,
                child: ActionCard(
                  action: actions[2],
                  onTap: () => onActionTap(2),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            // Card 3 — Secondary
            Expanded(
              child: SizedBox(
                height: 130.h,
                child: ActionCard(
                  action: actions[3],
                  onTap: () => onActionTap(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
