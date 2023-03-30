import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

abstract class AiOpponent{
  const AiOpponent();

  Tile chooseNextMove(BoardState state);
}