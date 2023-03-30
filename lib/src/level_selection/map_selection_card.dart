import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/level_selection/game_map.dart';
import 'package:tictactoe/src/play_session/board_lines.dart';
import 'package:tictactoe/src/style/palette.dart';

class MapSelectionCard extends StatelessWidget {
  final GameMap map;

  const MapSelectionCard(this.map, {Key? key}) : super(key: key);

  onClick(BuildContext context) {
    GoRouter.of(context).go("/play/vs/session/${map.id}");
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return InkWell(
      onTap: ()=>onClick(context),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: AspectRatio(
                aspectRatio: 1,
                child: BoardLines(m: map.setting.m, n: map.setting.n)),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(color: palette.trueWhite, borderRadius: BorderRadius.circular(6)),
              child: Text(
                "${map.setting.m} X ${map.setting.n}",
                style:
                TextStyle(color: palette.redPen, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "match ${map.setting.k} tiles",
              style:
              TextStyle(color: palette.ink, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
