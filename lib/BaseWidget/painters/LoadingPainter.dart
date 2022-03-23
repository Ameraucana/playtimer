import 'package:flutter/material.dart';
import 'package:playtimer/classes/LoadingIndicator/SquareTrain.dart';

class LoadingPainter extends CustomPainter {
  LoadingPainter({@required this.train}) {
    padding = 3;
    squareFaceLength = 6;
    squareCoords = {
      0: Offset(padding, padding),
      1: Offset(padding * 2 + squareFaceLength, padding),
      2: Offset(padding * 3 + squareFaceLength * 2, padding),
      3: Offset(
          padding * 3 + squareFaceLength * 2, padding * 2 + squareFaceLength),
      4: Offset(padding * 3 + squareFaceLength * 2,
          padding * 3 + squareFaceLength * 2),
      5: Offset(
          padding * 2 + squareFaceLength, padding * 3 + squareFaceLength * 2),
      6: Offset(padding, padding * 3 + squareFaceLength * 2),
      7: Offset(padding, padding * 2 + squareFaceLength),
    };
  }

  SquareTrain train;
  double padding;
  double squareFaceLength;
  Map<int, Offset> squareCoords;

  @override
  void paint(Canvas canvas, Size size) {
    train.carPositions.forEach((car) => canvas.drawRect(
        Rect.fromLTWH(squareCoords[car].dx, squareCoords[car].dy,
            squareFaceLength, squareFaceLength),
        Paint()..color = Colors.white));
  }

  bool shouldRepaint(old) {
    return true;
  }
}
