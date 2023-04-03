import 'dart:math';

import 'package:tictactoe/src/ai/random_opponent.dart';
import 'package:tictactoe/src/ai/smart_opponent.dart';
import 'package:tictactoe/src/ai/thinking_opponent.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

abstract class AiOpponent {
  const AiOpponent();

  Tile chooseNextMove(BoardState state);

  static AiOpponent getRandomOpponent() {
    final Random _random = Random();
    final _randomNum = _random.nextInt(3);
    return _randomNum == 0
        ? RandomOpponent()
        : _randomNum == 1
            ? ThinkingOpponent()
            : SmartOpponent();
  }

  static String getSimulationOpponentName(AiOpponent? opponent) =>
      opponent is RandomOpponent
          ? "Dumb"
          : opponent is ThinkingOpponent
              ? "Average"
              : opponent is SmartOpponent
                  ? "Smart"
                  : "..";
}
