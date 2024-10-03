import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CommonTabBar extends StatelessWidget {
  const CommonTabBar({
    super.key,
    required TabController tabController,
    required this.tabs,
  }) : _tabController = tabController;

  final TabController _tabController;
  final List<Widget> tabs;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      dividerColor: appTheme.white,
      labelStyle: textTheme.bodyMedium!.copyWith(
        color: appTheme.tertiary,
        fontWeight: FontWeight.w700,
      ),
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.only(left: 10, right: 10),
      labelColor: appTheme.tertiary,
      unselectedLabelStyle: textTheme.bodyMedium!.copyWith(
        color: appTheme.tertiary,
        fontWeight: FontWeight.normal,
      ),
      unselectedLabelColor: appTheme.tertiary,
      indicator: CircleTabIndicator(color: appTheme.tertiary, radius: 4),
      tabs: tabs,
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  final double radius;

  const CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  final double radius;

  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    paint.color = color;
    paint.isAntiAlias = true;
    final Offset circleOffset = Offset(
      configuration.size!.width / 2 + offset.dx,
      configuration.size!.height - radius, // Adjust 5 for margin from text
    );
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
