import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/tile.dart';
import 'package:tictactoe/src/play_session/board_lines.dart';
import 'package:tictactoe/src/play_session/board_tile.dart';
import 'package:tictactoe/src/style/palette.dart';

class MainBoardSession extends StatelessWidget {
  const MainBoardSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoardSetting _setting =
        context.select((BoardState state) => state.setting);
    final List _winningLines =
        context.select((BoardState state) => state.winnerLines);
    final palette = context.watch<Palette>();
    return AspectRatio(
      aspectRatio: _setting.m / _setting.n,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BoardLines(m: _setting.m, n: _setting.n, color: palette.text,),
          ..._winningLines
              .map((line) => WinningLines(
                  m: _setting.m, n: _setting.n, tile1: line[0], tile2: line[1]))
              .toList(),
          // WinningLines(m: m, n: n, tile1: Tile(0,0), tile2: Tile(2,2)),
          // WinningLines(m: m, n: n, tile1: Tile(0,0), tile2: Tile(0,2)),
          // WinningLines(m: m, n: n, tile1: Tile(0,0), tile2: Tile(2,0)),
          GridView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _setting.m,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4),
              itemCount: _setting.m * _setting.n,
              itemBuilder: (context, index) => BoardTile(
                    tile: Tile(index % _setting.m, index ~/ _setting.n),
                  )),
        ],
      ),
    );
  }
}
