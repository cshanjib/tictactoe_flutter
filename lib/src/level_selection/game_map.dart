import 'package:tictactoe/src/game_internals/board_setting.dart';

class GameMap {
  final int id;
  final BoardSetting setting;

  const GameMap(this.id, this.setting);

  @override
  String toString() => '${setting.m} X ${setting.n}';

  @override
  bool operator ==(Object other) {
    return other is GameMap && other.id == id && other.setting == setting;
  }

  @override
  int get hashCode => Object.hash(id, setting);
}

const gameMaps = [
  GameMap(1, BoardSetting(3, 3, 3, gameId: 1)),
  GameMap(2, BoardSetting(4, 4, 3, gameId: 2)),
  GameMap(3, BoardSetting(4, 4, 4, gameId: 3)),
  GameMap(4, BoardSetting(5, 5, 4, gameId: 4)),
];

const gameMapList = [
  GameMap(1, BoardSetting(3, 3, 3, gameId: 1)),
  GameMap(2, BoardSetting(4, 4, 4, gameId: 2)),
  GameMap(3, BoardSetting(5, 5, 5, gameId: 3)),
];
