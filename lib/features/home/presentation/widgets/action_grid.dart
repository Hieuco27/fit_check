import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fit_check/features/home/domain/entities/home_action.dart';
import 'package:fit_check/features/home/presentation/widgets/action_card.dart';

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
            Expanded(
              child: SizedBox(
                height: 124.h,
                child: ActionCard(
                  action: actions[0],
                  onTap: () => onActionTap(0),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: 124.h,
                child: ActionCard(
                  action: actions[1],
                  onTap: () => onActionTap(1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 124.h,
                child: ActionCard(
                  action: actions[2],
                  onTap: () => onActionTap(2),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: 124.h,
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
