import 'package:flutter/cupertino.dart';
import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/tile.dart';
import 'package:tictactoe/src/game_internals/winner_result.dart';
import 'package:tictactoe/src/helpers/helper_functions.dart';

class BoardState extends ChangeNotifier {
  Map<Tile, Side> _moves = {};

  Map<Tile, Side> get moves => _moves;

  bool _isLocked = true;

  bool get isLocked => _isLocked;

  String getValueAt(Tile tile) => moves[tile]?.name ?? "";

  List winnerLines = [];
  List winCombos = [];
  final bool simulate;

  bool get hasGameStarted => _moves.length > 0;

  bool get isAiPlaying => setting.isAiPlaying;

  final ValueNotifier<Side?> gameResult = ValueNotifier<Side?>(null);

  bool canOccupyTile(Tile tile) =>
      _moves[tile] == Side.NONE || _moves[tile] == null;

  bool hasValueIn(pos) => _moves[pos] == Side.X || _moves[pos] == Side.O;

  Side get currentTurn => _moves.length % 2 == 0
      ? (setting.opponentStarts ? setting.opponentSide : setting.playerSide)
      : (setting.opponentStarts ? setting.playerSide : setting.opponentSide);

  final BoardSetting setting;

  BoardState._(this.setting, {this.simulate = false});

  BoardState.new(BoardSetting setting, {bool? simulate})
      : this._(setting, simulate: simulate ?? false);

  void initializeBoard() {
    if (simulate) {
      simulation();
    } else {
      _isLocked = false;
      //make the first move for Ai when playing against Ai and it starts first
      if (setting.isAiPlaying && setting.opponentStarts) {
        _moves.addAll({Tile(setting.m ~/ 2, setting.n ~/ 2): currentTurn});
      }
      notifyListeners();
    }
  }

  void simulation({ai1, ai2}) async {
    AiOpponent aiOpponent1 = ai1 ?? AiOpponent.getRandomOpponent();
    AiOpponent aiOpponent2 = ai2 ?? AiOpponent.getRandomOpponent();

    occupyTile((_moves.length % 2 == 0 ? aiOpponent1 : aiOpponent2)
        .chooseNextMove(this));
    await Future.delayed(Duration(seconds: 2));
    if (gameResult.value == null) {
      simulation(ai1: aiOpponent1, ai2: aiOpponent2);
    } else {
      _moves.clear();
      notifyListeners();
      await Future.delayed(Duration(seconds: 2));
      clearBoard();
    }
  }

  void clearBoard() {
    _moves.clear();
    winnerLines.clear();
    winCombos.clear();
    gameResult.value = null;
    initializeBoard();
  }

  @override
  void dispose() {
    gameResult.dispose();
    super.dispose();
  }

  bool get isGameDraw => _moves.length == setting.m * setting.n;

  bool get isPlayer1Winner => setting.playerSide == gameResult.value;

  void occupyTile(Tile tile, {bool isAiMove = false}) {
    final _turn = currentTurn;
    _moves = {...moves, tile: _turn};
    _isLocked = true;
    notifyListeners();

    bool hasWinner = hasSomeoneWon(tile, _turn);

    if (hasWinner) {
      //someone wins
      gameResult.value = _turn;
      gameResult.notifyListeners();
    } else if (isGameDraw) {
      //game is draw
      gameResult.value = Side.NONE;
      gameResult.notifyListeners();
    } else if (isAiPlaying && !isAiMove) {
      //make the move for ai if playing against Ai
      occupyTile(setting.aiOpponent!.chooseNextMove(this), isAiMove: true);
    } else {
      //continue the game
      _isLocked = false;
      notifyListeners();
    }
  }

  bool hasSomeoneWon(Tile tile, Side currentSide,
      {checkOnly = false,
      CheckDirection direction = CheckDirection.vertical,
      hasWinner = false}) {
    final _result = HelperFunctions.checkForWinner(
        tile, currentSide, setting, moves,
        direction: direction, checkOnly: checkOnly);

    if (_result is bool && _result && checkOnly) {
      return true;
    } else if (_result is WinnerResult) {
      hasWinner = true;
      winnerLines = [...winnerLines, _result.winnerLines];
      winCombos.addAll(_result.winnerCombos);
    }

    return direction == CheckDirection.bottomLeftToTopRight
        ? hasWinner
        : hasSomeoneWon(tile, currentSide,
            checkOnly: checkOnly,
            hasWinner: hasWinner,
            direction: direction == CheckDirection.vertical
                ? CheckDirection.horizontal
                : direction == CheckDirection.horizontal
                    ? CheckDirection.bottomRightToTopLeft
                    : CheckDirection.bottomLeftToTopRight);

  }
}
