import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/level_selection_state.dart';
import 'package:tictactoe/src/level_selection/levels.dart';
import 'package:tictactoe/src/style/palette.dart';

class LevelSelectionCard extends StatelessWidget {
  final GameLevel level;
  final int index;

  const LevelSelectionCard(this.level, {Key? key, this.index = 0})
      : super(key: key);

  onClick(BuildContext context) {
    GoRouter.of(context).go("/play/single/session/${level.id}",
        extra: context.read<LevelSelectionState>().setting);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return InkWell(
      onTap: () => onClick(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Transform.rotate(
              angle: (pi / 4) * ((index + 1)),
              child: Text(
                "*",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    fontSize: 240,
                    color: palette.backgroundMain,
                    fontFamily: "Cloudy"),
              ),
            ),
          ),
          Center(
            child: Text(
              "${level.id}",
              style: TextStyle(
                  fontSize: 60, color: palette.redPen, fontFamily: "Cloudy"),
            ),
          ),
        ],
      ),
    );
  }
}
