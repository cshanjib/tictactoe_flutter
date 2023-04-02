import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/main_menu/animate_o.dart';
import 'package:tictactoe/src/main_menu/animate_x.dart';
import 'package:tictactoe/src/play_session/board_lines.dart';
import 'package:tictactoe/src/style/palette.dart';

class MainAnimation extends StatelessWidget {
  const MainAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Center(
        child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                BoardLines(
                  m: 3,
                  n: 3,
                  color: palette.text,
                  strokeWidth: 5,
                ),
                XOAnimator()
              ],
            )));
  }
}

class XOAnimator extends StatefulWidget {
  const XOAnimator({Key? key}) : super(key: key);

  @override
  State<XOAnimator> createState() => _XOAnimatorState();
}

class _XOAnimatorState extends State<XOAnimator> {
  final Random _random = Random();
  Map<int, Side> _moves = {};
  List currentAnimation = [];

  bool hasValueIn(pos) => _moves[pos] == Side.X || _moves[pos] == Side.O;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        _moves[calculateRandomPos()] = Side.X;
      });
    });

    Future.delayed(Duration(seconds: 4)).then((value) {
      setState(() {
        _moves[calculateRandomPos()] = Side.O;
      });
    });

    Future.delayed(Duration(seconds: 7)).then((value) {
      setState(() {
        _moves[calculateRandomPos()] = Side.X;
      });
    });

    Future.delayed(Duration(seconds: 10)).then((value) {
      setState(() {
        _moves[calculateRandomPos()] = Side.O;
      });
    });
  }

  int calculateRandomPos() {
    int num = _random.nextInt(9);
    return hasValueIn(num) ? calculateRandomPos() : num;
  }

  onEnd(val) {
    if (hasValueIn(val)) {
      setState(() {
        _moves[calculateRandomPos()] = _moves[val]!;

        _moves.removeWhere((key, value) => key == val);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return GridView.builder(
      itemCount: 9,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) => Center(
          child: AnimatedOpacity(
        // opacity: hasValueIn(index) ? 1 : 0,
        opacity: 1,
        duration: Duration(seconds: 5),
        onEnd: () => onEnd(index),
        child: hasValueIn(index)
            ? _moves[index] == Side.O
                ? AnimateO(color: palette.text)
                : AnimateX(color: palette.text)
            : Text(
                "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Cloudy', fontSize: 70, color: palette.text),
              ),
      )),
    );
  }
}
