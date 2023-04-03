import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimateX extends StatefulWidget {
  final Color color;

  const AnimateX({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  State<AnimateX> createState() => _AnimateXState();
}

class _AnimateXState extends State<AnimateX>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    // _controller.value = 1;

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final progress =
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

        return Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: progress,
              builder: (context, child) {
                return ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black,
                        Colors.white.withOpacity(0),
                      ],
                      stops: [
                        progress.value * 2,
                        progress.value * 2 + 0.05,
                      ],
                    ).createShader(bounds);
                  },
                  child: child,
                );
              },
              child: Transform.rotate(
                angle: -math.pi / 5,
                child: SizedBox(
                  width: constraints.biggest.width,
                  child: FittedBox(
                    child: Text(
                      "I",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontFamily: 'Cloudy', color: widget.color),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: progress,
              builder: (context, child) {
                return ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.black,
                        Colors.white.withOpacity(0),
                      ],
                      stops: [
                        -1 + progress.value * 2,
                        -1 + progress.value * 2 + 0.05,
                      ],
                    ).createShader(bounds);
                  },
                  child: child,
                );
              },
              child: Transform.rotate(
                angle: math.pi / 5,
                child: SizedBox(
                  width: constraints.biggest.width,
                  child: FittedBox(
                    child: Text(
                      "l",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontFamily: 'Cloudy', color: widget.color),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
