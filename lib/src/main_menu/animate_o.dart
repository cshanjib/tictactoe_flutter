import 'package:flutter/material.dart';


class AnimateO extends StatefulWidget {

  final Color color;

  const AnimateO({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  State<AnimateO> createState() => _AnimateOState();
}

class _AnimateOState extends State<AnimateO> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _controller.value = 1;

    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final progress =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);


        return AnimatedBuilder(
          animation: progress,
          builder: (context, child) {
            return ShaderMask(
              blendMode: BlendMode.dstOut,
              shaderCallback: (bounds) {
                return SweepGradient(
                  tileMode: TileMode.repeated,
                  // center: Alignment.topLeft,
                  transform: const GradientRotation( -110 / 180 *2),
                  colors: [
                    Colors.black,
                    Colors.white.withOpacity(0),
                  ],
                  stops: [
                    progress.value -0.05,
                    progress.value ,

                  ],
                ).createShader(bounds);
              },
              child: child,
            );
          },
          child: Text(
            "O",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Cloudy', fontSize: 70, color: widget.color),
          )
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