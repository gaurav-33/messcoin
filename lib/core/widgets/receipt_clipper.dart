import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double notchSize = 10.0; // Controls the size of the zigzag notches
    int notchCount = (size.width / notchSize).floor();

    // Start from top-left
    path.lineTo(0, notchSize);

    // Top zigzag edge
    for (int i = 0; i < notchCount; i++) {
      path.lineTo(notchSize * (i + 0.5), 0);
      path.lineTo(notchSize * (i + 1), notchSize);
    }

    // Right edge
    path.lineTo(size.width, size.height - notchSize);

    // Bottom zigzag edge
    for (int i = notchCount; i > 0; i--) {
      path.lineTo(notchSize * (i - 0.5), size.height);
      path.lineTo(notchSize * (i - 1), size.height - notchSize);
    }
    
    // Left edge
    path.lineTo(0, notchSize);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// This custom painter creates the dashed line separator.
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightDark.withOpacity(0.3)
      ..strokeWidth = 1;
      
    const double dashWidth = 5.0;
    const double dashSpace = 3.0;
    double startX = 0.0;
    
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldClipper) => false;
}