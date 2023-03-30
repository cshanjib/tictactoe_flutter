import 'dart:math';

import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

class RandomOpponent extends AiOpponent {
  const RandomOpponent();

  static final Random _random = Random();

  @override
  Tile chooseNextMove(BoardState state) {
    final options = <Tile>[];

    for (int x = 0; x < state.setting.m; x++) {
      for (int y = 0; y < state.setting.n; y++) {
        final tile = Tile(x, y);
        if (state.canOccupyTile(tile)) {
          options.add(tile);
        }
      }
    }

    return options[_random.nextInt(options.length)];
  }
}
