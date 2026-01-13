import 'package:flutter/material.dart';

class PaperBackground extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const PaperBackground({
    super.key,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PaperPainter(backgroundColor: backgroundColor),
      child: child,
    );
  }
}

class PaperPainter extends CustomPainter {
  final Color backgroundColor;

  PaperPainter({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background color
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw horizontal lines (like ruled paper)
    final linePaint = Paint()
      ..color = backgroundColor.computeLuminance() > 0.5
          ? Colors.black.withOpacity(0.1)
          : Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const lineSpacing = 32.0; // Space between lines
    const startY = 60.0; // Start after some padding

    for (double y = startY; y < size.height; y += lineSpacing) {
      canvas.drawLine(
        Offset(16, y),
        Offset(size.width - 16, y),
        linePaint,
      );
    }

    // Draw left margin line
    final marginPaint = Paint()
      ..color = backgroundColor.computeLuminance() > 0.5
          ? Colors.red.withOpacity(0.3)
          : Colors.red.withOpacity(0.2)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      const Offset(48, 0),
      Offset(48, size.height),
      marginPaint,
    );
  }

  @override
  bool shouldRepaint(covariant PaperPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor;
  }
}
