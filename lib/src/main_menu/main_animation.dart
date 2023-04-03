import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/tile.dart';
import 'package:tictactoe/src/main_menu/simulator_indicator.dart';
import 'package:tictactoe/src/play_session/board_lines.dart';
import 'package:tictactoe/src/play_session/board_tile.dart';
import 'package:tictactoe/src/style/palette.dart';
import 'package:tictactoe/src/widgets/foreground_detector.dart';

class MainAnimation extends StatelessWidget {
  const MainAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return ChangeNotifierProvider(
      create: (context) => BoardState.new(BoardSetting(3, 3, 3), simulate: true)
        ..initializeBoard(),
      child: Builder(builder: (context) {
        final setting = context.select((BoardState state) => state.setting);
        return Column(
          children: [
            Expanded(
              child: Center(
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          BoardLines(
                            m: setting.m,
                            n: setting.n,
                            color: palette.text,
                            strokeWidth: 5,
                          ),
                          XOAnimator()
                        ],
                      ))),
            ),
            SimulatorIndicator(),
          ],
        );
      }),
    );
  }
}

class XOAnimator extends StatelessWidget {
  const XOAnimator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final state = context.watch<BoardState>();
    return ForegroundDetector(
      onForegroundChanged: (isFor, hasGoneBack) async {
        if (!isFor) {
          state.stopSimulation();
        } else if (hasGoneBack) {
          state.reInitiateSimulation();
        }
      },
      child: GestureDetector(
        onTap: () {
          state.reInitiateSimulation();
        },
        child: GridView.builder(
            itemCount: 9,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              return BoardTile(
                tile: Tile(
                  index % state.setting.m,
                  index ~/ state.setting.n,
                ),
                clickable: false,
              );
            }),
      ),
    );
  }
}
