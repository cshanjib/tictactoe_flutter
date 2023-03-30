import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/level_selection/levels.dart';
import 'package:tictactoe/src/style/palette.dart';

class LevelSelectionCard extends StatelessWidget {
  final GameLevel level;

  const LevelSelectionCard(this.level, {Key? key}) : super(key: key);

  onClick(BuildContext context) {
    GoRouter.of(context).go("/play/single/session/${level.id}");
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return InkWell(
      onTap: () => onClick(context),
      child: Container(
        decoration: BoxDecoration(color: palette.trueWhite, borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            "${level.id}",
            style: TextStyle(

              fontWeight: FontWeight.bold, fontSize: 60, color: palette.redPen, ),
          ),
        ),
      ),
    );
  }
}
