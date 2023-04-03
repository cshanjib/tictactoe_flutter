import 'package:tictactoe/src/ai/random_opponent.dart';
import 'package:tictactoe/src/ai/smart_opponent.dart';
import 'package:tictactoe/src/ai/thinking_opponent.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';

const gameLevels = [
  GameLevel(
    id: 1,
    difficulty: 5,
    setting: BoardSetting(3, 3, 3, gameId: 1, aiOpponent: RandomOpponent()),
    // TODO: When ready, change these achievement IDs.
    // You configure this in App Store Connect.
    achievementIdIOS: 'first_win',
    // You get this string when you configure an achievement in Play Console.
    achievementIdAndroid: 'NhkIwB69ejkMAOOLDb',
  ),
  GameLevel(
      id: 2,
      difficulty: 42,
      setting: BoardSetting(3, 3, 3,
          gameId: 2, aiOpponent: RandomOpponent(), opponentStarts: true)),
  GameLevel(
    id: 3,
    setting: BoardSetting(4, 4, 3,
        gameId: 3, aiOpponent: RandomOpponent(), opponentStarts: true),
    difficulty: 100,
  ),
  GameLevel(
    id: 4,
    setting: BoardSetting(3, 3, 3, gameId: 4, aiOpponent: ThinkingOpponent()),
    difficulty: 200,
  ),
  GameLevel(
    id: 5,
    setting: BoardSetting(4, 4, 3,
        gameId: 5, aiOpponent: ThinkingOpponent(), opponentStarts: true),
    difficulty: 300,
  ),
  GameLevel(
    id: 6,
    setting: BoardSetting(5, 5, 4, gameId: 6, aiOpponent: ThinkingOpponent()),
    difficulty: 400,
  ),
  GameLevel(
    id: 7,
    setting: BoardSetting(5, 5, 4,
        gameId: 7, aiOpponent: ThinkingOpponent(), opponentStarts: true),
    difficulty: 400,
  ),
  GameLevel(
    id: 8,
    setting: BoardSetting(3, 3, 3, gameId: 8, aiOpponent: SmartOpponent()),
    difficulty: 500,
  ),
  GameLevel(
    id: 9,
    setting: BoardSetting(3, 3, 3,
        gameId: 9, aiOpponent: SmartOpponent(), opponentStarts: true),
    difficulty: 600,
  ),
];

class GameLevel {
  final int id;

  final int difficulty;

  final BoardSetting setting;

  /// The achievement to unlock when the level is finished, if any.
  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.id,
    required this.setting,
    required this.difficulty,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}
