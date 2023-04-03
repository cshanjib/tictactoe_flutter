import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/tile.dart';
import 'package:tictactoe/src/main_menu/animate_o.dart';
import 'package:tictactoe/src/main_menu/animate_x.dart';
import 'package:tictactoe/src/style/palette.dart';

class BoardTile extends StatelessWidget {
  final Tile tile;
  final bool clickable;

  const BoardTile({Key? key, required this.tile, this.clickable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileValue =
        context.select((BoardState state) => state.getValueAt(tile));
    final List winningCombos =
        context.select((BoardState state) => state.winCombos);
    final _isInWinningCombo = winningCombos.contains(tile);
    final _palette = context.read<Palette>();
    return InkWell(
        onTap: clickable
            ? () {
                final _state = context.read<BoardState>();
                if (!_state.isLocked && _state.canOccupyTile(tile)) {
                  _state.occupyTile(tile);
                }
              }
            : null,
        child: Center(
            child: AnimatedScale(
                scale: _isInWinningCombo ? 1.5 : 1,
                duration: const Duration(milliseconds: 300),
                child: tileValue == Side.O.name
                    ? AnimateO(
                        color: _isInWinningCombo
                            ? _palette.redPen
                            : _palette.colorOption2)
                    : tileValue == Side.X.name
                        ? AnimateX(
                            color: _isInWinningCombo
                                ? _palette.redPen
                                : _palette.colorOption1)
                        : SizedBox.shrink())));
  }
}
