import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CustomShapePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = appTheme.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    Path path = Path();

    path.moveTo(0, size.height * 0.20);
    path.lineTo(0, size.height * .20);

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.32,
      size.width,
      size.height * 0.20,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
