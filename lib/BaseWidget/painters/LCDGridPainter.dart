import 'package:flutter/material.dart';

class LCDGridPainter extends CustomPainter {
  Paint backgroundPaint = Paint()
    ..color = Color(0xFF00008F)
    ..strokeWidth = .5;

  @override
  void paint(Canvas canvas, Size size) {
    //int pixelLength = size.width ~/ 122;
    int pixelLength = 6;
    // horizontal lines
    for (int pos = 0; pos < size.height; pos += pixelLength)
    {
      canvas.drawLine(Offset(0, pos.toDouble()), Offset(size.width, pos.toDouble()), backgroundPaint);
    }
    
    // vertical lines
    for (int pos = 0; pos < size.width; pos += pixelLength)
    {
      canvas.drawLine(Offset(pos.toDouble(), 0), Offset(pos.toDouble(), size.height), backgroundPaint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
