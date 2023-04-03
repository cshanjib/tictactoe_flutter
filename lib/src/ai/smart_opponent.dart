import 'dart:math';

import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

class SmartOpponent extends AiOpponent {
  const SmartOpponent();

  @override
  Tile chooseNextMove(BoardState state) {
    final options = <Tile>[];

    final startTime = DateTime.now();

    for (int x = 0; x < state.setting.m; x++) {
      for (int y = 0; y < state.setting.n; y++) {
        final tile = Tile(x, y);
        if (state.canOccupyTile(tile)) {
          options.add(tile);
        }
      }
    }

    late Tile bestMove;
    var bestScore = -1;

    for(int i=0;i<options.length;i++){
      // state.moves[options[i]] = state.currentTurn;

      //calculate the score for the move
      var score = minimax(state, options[i], false, options.where((Tile tile) => tile!=options[i]).toList(), -1, 1);
      //undo the move
      state.moves.remove(options[i]);
      //compare the scores and choose the best one
      //ai is maximizing player, so the best score should be the higher values
      if(score > bestScore){
        bestScore = score;
        bestMove = options[i];
      }
    }

    // print("Total time: ${DateTime.now().difference(startTime).inMilliseconds}");

    return bestMove;
  }

  int minimax(BoardState state, Tile tile, isMaximizing, List<Tile> remainingOptions, alpha, beta){

    Side _turn = state.currentTurn;
    //make the move
    state.moves[tile] = _turn;

    if(state.hasSomeoneWon(tile, _turn, checkOnly: true)){
      return isMaximizing ? -1:1;
    }else if(state.isGameDraw){
      return 0;
    }

    if(isMaximizing){
      var bestScore = -1;

      for(int i=0;i<remainingOptions.length;i++){
        //calculate score
        var score = minimax(state, remainingOptions[i], false, remainingOptions.where((Tile tile) => tile!=remainingOptions[i]).toList(), alpha, beta);
        state.moves.remove(remainingOptions[i]);
        //here we are calculating the best move for the ai which is the maximizing player
        //so the bestScore will be the higher values
        if(score>bestScore) bestScore = score;
        alpha = max<int>(alpha, bestScore);
        if(beta<=alpha) break;
      }

      return bestScore;

    }else{
      var bestScore = 1;

      for(int i=0;i<remainingOptions.length;i++){
        //calculate score
        var score = minimax(state, remainingOptions[i], true, remainingOptions.where((Tile tile) => tile!=remainingOptions[i]).toList(), alpha, beta);
        state.moves.remove(remainingOptions[i]);
        //here we are calculating the best move for the player which is the minimizing player
        //so the bestScore will be the lower values
        if(score<bestScore) bestScore = score;
        beta = min<int>(beta, bestScore);
        if(beta<=alpha) break;
      }

      return bestScore;
    }

  }
}
