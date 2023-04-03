import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/ai/random_opponent.dart';
import 'package:tictactoe/src/ai/smart_opponent.dart';
import 'package:tictactoe/src/ai/thinking_opponent.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/tile.dart';
import 'package:tictactoe/src/game_internals/winner_result.dart';

abstract class HelperFunctions {
  static checkForWinner(
      Tile tile, Side currentSide, BoardSetting setting, Map<Tile, Side> moves,
      {checkOnly = false, CheckDirection direction = CheckDirection.vertical}) {
    int _winningCount = 0;
    bool _hasWinner = false;
    List _tempWinCombos = [];
    List winnerLines = [];
    List winCombos = [];
    Tile _startTile = tile;
    Tile _endTile = tile;
    bool _mismatchTop = false;
    bool _mismatchBottom = false;

    for (int i = 1; i < setting.k; i++) {
      //check downwards
      final downwardTile = Tile.downwardTile(tile, i, direction: direction);
      if (moves[downwardTile] == currentSide && !_mismatchTop) {
        _winningCount++;
        _startTile = downwardTile;
        _tempWinCombos.add(downwardTile);
      } else {
        _mismatchTop = true;
      }

      //check upwards
      final upwardTile = Tile.upwardTile(tile, i, direction: direction);
      if (moves[upwardTile] == currentSide && !_mismatchBottom) {
        _winningCount++;
        _endTile = upwardTile;
        _tempWinCombos.add(_endTile);
      } else {
        _mismatchBottom = true;
      }
      if (_mismatchTop && _mismatchBottom) {
        break;
      }

      if (_winningCount >= setting.k - 1) {
        if (checkOnly) {
          return true;
        }
        _hasWinner = true;
        winnerLines = [_startTile, _endTile];
        winCombos.addAll(_tempWinCombos);
        winCombos.add(tile);

        return WinnerResult(winnerLines, winCombos);
      }
    }

    return _hasWinner;
  }

  static String getSimulationOpponentName(AiOpponent? opponent) =>
      opponent is RandomOpponent
          ? "Random"
          : opponent is ThinkingOpponent
              ? "Think"
              : opponent is SmartOpponent
                  ? "Smart"
                  : "..";
}
