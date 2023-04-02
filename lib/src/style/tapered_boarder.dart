import 'package:flutter/material.dart';

class TaperedBorder extends ShapeBorder {
  final double strokeWidth = 8.0;
  final bool reverse;
  final Color borderColor;

  TaperedBorder({this.reverse = false, this.borderColor=Colors.red});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, 20));
    // return Path()
    //   ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
    //   ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
    //   ..relativeLineTo(10, 20)
    //   ..relativeLineTo(20, -20)
    //   ..close();
    final adjust = strokeWidth / 2;

    if (reverse) {
      return Path()
        // ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
        ..moveTo(rect.topRight.dx - adjust, rect.topRight.dy + adjust)

        ..lineTo(rect.topLeft.dx + adjust + 10, rect.topLeft.dy + adjust + 10)
        ..lineTo(rect.topLeft.dx + adjust, rect.topLeft.dy + adjust + 20)

        ..lineTo(rect.bottomLeft.dx + adjust + 10,
            rect.bottomLeft.dy - adjust - 10)
        ..lineTo(
            rect.bottomLeft.dx + adjust +  20, rect.bottomLeft.dy - adjust - 5)

        ..lineTo(rect.bottomRight.dx - adjust, rect.bottomLeft.dy - adjust)
        // ..lineTo(0,0)
        ..close();
    } else {
      return Path()
        ..moveTo(adjust, adjust)
        ..lineTo(rect.topRight.dx - adjust - 10, rect.topRight.dy + adjust + 10)
        ..lineTo(rect.topRight.dx - adjust, rect.topRight.dy + adjust + 20)
        ..lineTo(rect.bottomRight.dx - adjust - 10,
            rect.bottomRight.dy - adjust - 10)
        ..lineTo(
            rect.bottomRight.dx - adjust - 20, rect.bottomRight.dy - adjust - 5)
        ..lineTo(rect.bottomLeft.dx + adjust, rect.bottomLeft.dy - adjust)
        // ..lineTo(0,0)
        ..close();
    }
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    Paint paint = new Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawPath(getOuterPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
