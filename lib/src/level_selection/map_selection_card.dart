import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/level_selection_state.dart';
import 'package:tictactoe/src/level_selection/game_map.dart';
import 'package:tictactoe/src/play_session/board_lines.dart';
import 'package:tictactoe/src/style/palette.dart';

class MapSelectionCard extends StatelessWidget {
  final GameMap map;
  final int matchNeeded;

  const MapSelectionCard(this.map, this.matchNeeded, {Key? key})
      : super(key: key);

  onClick(BuildContext context) {
    GoRouter.of(context).go("/play/vs/session/${map.id}",
        extra: context.read<LevelSelectionState>().setting.update(
            m: map.setting.m,
            n: map.setting.n,
            k: matchNeeded,
            gameId: map.id,
            playerIsX: context.read<LevelSelectionState>().setting.playerSide ==
                Side.X));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: InkResponse(
          onTap: () => onClick(context),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: AspectRatio(
                    aspectRatio: 1,
                    child: BoardLines(
                      m: map.setting.m,
                      n: map.setting.n,
                      color: palette.backgroundMain,
                    )),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: palette.trueWhite,
                      borderRadius: BorderRadius.circular(40)),
                  child: Stack(
                    // mainAxisSize: MainAxisSize.min,
                    fit: StackFit.expand,
                    children: [
                      Icon(
                        Icons.play_arrow_outlined,
                        size: 70,
                        color: palette.redPen,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "${map.setting.m} X ${map.setting.n}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: palette.redPen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "match ${matchNeeded} tiles",
                  style: TextStyle(
                      color: palette.backgroundMain,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
