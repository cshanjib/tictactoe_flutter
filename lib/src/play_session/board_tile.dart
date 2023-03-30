import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/tile.dart';
import 'package:tictactoe/src/style/palette.dart';

class BoardTile extends StatelessWidget {
  final Tile tile;

  const BoardTile({Key? key, required this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileValue =
        context.select((BoardState state) => state.getValueAt(tile));
    final List winningCombos =
        context.select((BoardState state) => state.winCombos);
    final _isInWinningCombo = winningCombos.contains(tile);
    final _palette = context.read<Palette>();
    return InkWell(
        onTap: () {
          final _state = context.read<BoardState>();
          if (!_state.isLocked && _state.canOccupyTile(tile)) {
            _state.occupyTile(tile);
          }
        },
        child: Center(
            child: AnimatedScale(
          scale: _isInWinningCombo ? 1.5 : 1,
          duration: const Duration(milliseconds: 300),
          child: Text(
            tileValue,
            style: _isInWinningCombo
                ? TextStyle(
                    fontSize: 40,
                    color: _palette.redPen,
                    fontWeight: FontWeight.bold)
                : TextStyle(fontSize: 40),
          ),
        )));
  }
}
