import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/tile.dart';
import 'package:tictactoe/src/main_menu/animate_o.dart';
import 'package:tictactoe/src/main_menu/animate_x.dart';
import 'package:tictactoe/src/main_menu/simulator_indicator.dart';
import 'package:tictactoe/src/play_session/board_lines.dart';
import 'package:tictactoe/src/style/palette.dart';

class MainAnimation extends StatelessWidget {
  const MainAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return ChangeNotifierProvider(
      create: (context) =>
          BoardState.new(BoardSetting(3, 3, 3), simulate: true),
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
    return GridView.builder(
        itemCount: 9,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          final tile = Tile(index % state.setting.m, index ~/ state.setting.n);
          bool _isInWinnerCombo = state.winCombos.contains(tile);
          return Center(
              child: AnimatedScale(
                  scale: _isInWinnerCombo ? 1.3 : 1,
                  duration: Duration(seconds: 2),
                  child: state.hasValueIn(tile)
                      ? state.getValueAt(tile) == Side.O.name
                          ? AnimateO(
                              color: _isInWinnerCombo
                                  ? palette.redPen
                                  : palette.colorOption2)
                          : AnimateX(
                              color: _isInWinnerCombo
                                  ? palette.redPen
                                  : palette.colorOption1)
                      : SizedBox.shrink()));
        });
  }
}
