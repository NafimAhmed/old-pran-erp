import 'package:flutter/material.dart';
import 'package:pran_rfl_erp/core/theme/app_theme.dart';

class CustomBackgroundShapePainter extends CustomPainter {
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

// Start from top-left with a curve
    path.moveTo(0, size.height * 0.40);
    path.quadraticBezierTo(
      size.width * 0.01, // Control point X for the curve
      size.height * 0.35, // Control point Y for the curve
      size.width * 0.08, // Ending X for the curve
      size.height * 0.35, // Ending Y for the curve
    );

// Continue with the top-right curve
    path.lineTo(size.width * 0.90, size.height * 0.35);
    path.quadraticBezierTo(
      size.width * 0.99, // Control point X for the curve
      size.height * 0.35, // Control point Y for the curve
      size.width, // Ending X for the curve
      size.height * 0.40, // Ending Y for the curve
    );

// Draw the remaining sides
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

// Close and draw the path
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
