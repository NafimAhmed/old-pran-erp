import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CustomShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = appTheme.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    Path path = Path();
    // path.lineTo(0, size.height * 0.65);
    // path.quadraticBezierTo(
    //     size.width * 0.5, size.height * 0.85, size.width, size.height * 0.75);
    // path.lineTo(size.width, size.height * 0.75);
    // path.lineTo(size.width, 0);

    path.moveTo(0, size.height * 0.65);
    path.lineTo(0, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.45, size.height * 0.88, size.width, size.height * 0.75);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
