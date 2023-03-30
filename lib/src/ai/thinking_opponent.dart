import 'dart:math';

import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

class ThinkingOpponent extends AiOpponent {
  const ThinkingOpponent();

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

    //check for the AI win
    Side _aiSide = state.currentTurn;

    for(int i=0;i<options.length;i++){
      if(state.hasSomeoneWon(options[i], _aiSide, checkOnly: true)){
        return options[i];
      }
    }

    //check for the player win to block the win if found
    Side _playerSide = _aiSide == Side.X ? Side.O:Side.X;

    for(int i=0;i<options.length;i++){
      if(state.hasSomeoneWon(options[i], _playerSide, checkOnly: true)){
        return options[i];
      }
    }

    //choose random move
    return options[_random.nextInt(options.length)];
  }
}
