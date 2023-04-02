import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/tile.dart';
import 'package:tictactoe/src/style/palette.dart';

class BoardLines extends StatelessWidget {
  final int m;
  final int n;
  final Color? color;
  final double? strokeWidth;

  const BoardLines({Key? key, required this.m, required this.n, this.color, this.strokeWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        child: CustomPaint(
      painter: GamesLinesPainter(m, n, lineColor: color ?? Colors.black, strokeWidth: strokeWidth ),
    ));
  }
}

class GamesLinesPainter extends CustomPainter {
  final int m;
  final int n;
  final Color lineColor;
  final double? strokeWidth;

  late final pathPaint = Paint()
    ..colorFilter = ColorFilter.mode(lineColor, BlendMode.srcIn);

  GamesLinesPainter(this.m, this.n, {required this.lineColor, this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 10.0;
    pathPaint.strokeWidth = strokeWidth ?? 8;

    //draw horizontal lines
    final heightStep = size.height / n;
    for (int i = 1; i < n; i++) {
      canvas.drawLine(Offset(padding, i * heightStep),
          Offset(size.width - padding, i * heightStep), pathPaint);
    }

    //draw vertical lines
    final widthStep = size.width / m;
    for (int i = 1; i < m; i++) {
      canvas.drawLine(Offset(i * widthStep, padding),
          Offset(i * widthStep, size.height - padding), pathPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GamesLinesPainter oldDelegate) {
    return oldDelegate.m != m ||
        oldDelegate.n != n ||
        oldDelegate.lineColor != lineColor;
  }
}

class WinningLines extends StatelessWidget {
  final int m;
  final int n;
  final Tile tile1;
  final Tile tile2;

  const WinningLines(
      {Key? key,
      required this.m,
      required this.n,
      required this.tile1,
      required this.tile2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return RepaintBoundary(
        child: CustomPaint(
      painter: WinningLinesPainter(m, n, lineColor: palette.redPen, tile1, tile2),
    ));
  }
}

class WinningLinesPainter extends CustomPainter {
  final int m;
  final int n;
  final Color lineColor;
  final Tile tile1;
  final Tile tile2;

  late final pathPaint = Paint()
    ..colorFilter = ColorFilter.mode(lineColor, BlendMode.srcIn);

  WinningLinesPainter(this.m, this.n, this.tile1, this.tile2,
      {this.lineColor = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 10.0;
    pathPaint.strokeWidth = 8;

    final heightStep = size.height / n;
    final widthStep = size.width / m;
    final adjustX = widthStep - padding;
    final adjustY = heightStep - padding;

    final p1 = Offset(
        (tile1.x * widthStep) +
            (tile1.x == tile2.x
                ? widthStep / 2
                : tile1.x > tile2.x
                    ? adjustX
                    : padding),
        (tile1.y * heightStep) +
            (tile1.y == tile2.y
                ? heightStep / 2
                : tile1.y >= tile2.y
                    ? adjustY
                    : padding));

    final p2 = Offset(
        (tile2.x * widthStep) +
            (tile1.x == tile2.x
                ? widthStep / 2
                : tile2.x >= tile1.x
                    ? adjustX
                    : padding),
        (tile2.y * heightStep) +
            (tile1.y == tile2.y
                ? heightStep / 2
                : tile2.y >= tile1.y
                    ? adjustY
                    : padding));

    canvas.drawLine(p1, p2, pathPaint);
  }

  @override
  bool shouldRepaint(covariant WinningLinesPainter oldDelegate) {
    return oldDelegate.m != m ||
        oldDelegate.n != n ||
        oldDelegate.tile1 != tile1 ||
        oldDelegate.tile2 != tile2 ||
        oldDelegate.lineColor != lineColor;
  }
}
