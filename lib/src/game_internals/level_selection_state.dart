import 'package:flutter/foundation.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/level_selection/game_map.dart';

class LevelSelectionState extends ChangeNotifier {
  BoardSetting setting;
  GameMap selectedMap = gameMapList[0];
  List<int> matchesReqList = _evaluateMatchesList(gameMapList[0]);
  int matchRequired = gameMapList[0].setting.k;

  LevelSelectionState({required this.setting});

  int _progress = 0;

  int get progress => _progress;

  void togglePlayerOptions() {
    setting = setting.update(playerIsX: setting.playerSide != Side.X);
    notifyListeners();
  }

  void updateGameMap(GameMap? map) {
    if (map == null) return;
    selectedMap = map;
    matchesReqList = _evaluateMatchesList(map);
    matchRequired = matchesReqList[0];
    notifyListeners();
  }

  void updateMatches(int? matchReq) {
    if (matchReq == null) return;
    matchRequired = matchReq;
    notifyListeners();
  }

  static List<int> _evaluateMatchesList(GameMap map) {
    return map.setting.k <= 3
        ? [map.setting.k]
        : [map.setting.k - 1, map.setting.k];
  }
}
