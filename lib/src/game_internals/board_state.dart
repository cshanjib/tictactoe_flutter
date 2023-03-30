import 'package:flutter/cupertino.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

class BoardState extends ChangeNotifier {
  Map<Tile, Side> _moves = {};

  Map<Tile, Side> get moves => _moves;

  bool _isLocked = true;

  bool get isLocked => _isLocked;

  String getValueAt(Tile tile) => moves[tile]?.name ?? "";

  List winnerLines = [];
  List winCombos = [];

  bool get hasGameStarted => _moves.length > 0;

  bool get isAiPlaying => setting.isAiPlaying;

  final ValueNotifier<Side?> gameResult = ValueNotifier<Side?>(null);

  bool canOccupyTile(Tile tile) =>
      _moves[tile] == Side.NONE || _moves[tile] == null;

  Side get currentTurn => _moves.length % 2 == 0
      ? (setting.opponentStarts ? setting.opponentSide : setting.playerSide)
      : (setting.opponentStarts ? setting.playerSide : setting.opponentSide);

  final BoardSetting setting;

  BoardState._(this.setting);

  BoardState.new(BoardSetting setting) : this._(setting);

  void initializeBoard() {
    _isLocked = false;
    //make the first move for Ai when playing against Ai and it starts first
    if(setting.isAiPlaying && setting.opponentStarts){
      _moves.addAll({Tile(setting.m~/2, setting.n~/2): currentTurn});
    }
    notifyListeners();
  }

  void clearBoard() {
    _moves.clear();
    winnerLines.clear();
    winCombos.clear();
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

  bool hasSomeoneWon(Tile tile, Side currentSide, {checkOnly = false}) {
    int _winningCount = 0;
    bool _hasWinner = false;
    List _tempWinCombos = [];
    Tile _startTile = tile;
    Tile _endTile = tile;
    bool _mismatchTop = false;
    bool _mismatchBottom = false;

    //check for vertical lines
    for (int i = 1; i < setting.k; i++) {
      //check downwards
      final downwardTile = Tile(tile.x, tile.y - i);
      if (_moves[downwardTile] == currentSide && !_mismatchTop) {
        _winningCount++;
        _startTile = downwardTile;
        _tempWinCombos.add(downwardTile);
      }else{
        _mismatchTop = true;
      }

      //check upwards
      final upwardTile = Tile(tile.x, tile.y + i);
      if (_moves[upwardTile] == currentSide && !_mismatchBottom) {
        _winningCount++;
        _endTile = upwardTile;
        _tempWinCombos.add(_endTile);
      }else{
        _mismatchBottom = true;
      }
      if(_mismatchTop && _mismatchBottom){
        break;
      }

      if (_winningCount >= setting.k - 1) {
        if(checkOnly){
          return true;
        }
        _hasWinner = true;
        winnerLines = [
          ...winnerLines,
          [_startTile, _endTile]
        ];
        winCombos.addAll(_tempWinCombos);
        winCombos.add(tile);
        break;
      }
    }
    _startTile = tile;
    _endTile = tile;
    _winningCount = 0;
    _tempWinCombos.clear();
    _mismatchTop = false;
    _mismatchBottom = false;

    //check for horizontal lines
    for (int i = 1; i < setting.k; i++) {
      //check left
      final downwardTile = Tile(tile.x - i, tile.y);
      if (_moves[downwardTile] == currentSide && !_mismatchTop) {
        _winningCount++;
        _startTile = downwardTile;
        _tempWinCombos.add(downwardTile);
      }else{
        _mismatchTop = true;
      }

      //check right
      final upwardTile = Tile(tile.x + i, tile.y);
      if (_moves[upwardTile] == currentSide && !_mismatchBottom) {
        _winningCount++;
        _endTile = upwardTile;
        _tempWinCombos.add(_endTile);
      }else{
        _mismatchBottom = true;
      }

      if(_mismatchTop && _mismatchBottom){
        break;
      }

      if (_winningCount >= setting.k - 1) {
        if(checkOnly){
          return true;
        }
        _hasWinner = true;
        winnerLines = [
          ...winnerLines,
          [_startTile, _endTile]
        ];
        winCombos.addAll(_tempWinCombos);
        winCombos.add(tile);
        break;
      }
    }
    _startTile = tile;
    _endTile = tile;
    _winningCount = 0;
    _tempWinCombos.clear();
    _mismatchTop = false;
    _mismatchBottom = false;

    //check for diagonal lines: type1
    for (int i = 1; i < setting.k; i++) {
      //check upper left
      final downwardTile = Tile(tile.x - i, tile.y + i);
      if (_moves[downwardTile] == currentSide && !_mismatchTop) {
        _winningCount++;
        _startTile = downwardTile;
        _tempWinCombos.add(downwardTile);
      }else{
        _mismatchTop = true;
      }

      //check downward right
      final upwardTile = Tile(tile.x + i, tile.y - i);
      if (_moves[upwardTile] == currentSide && !_mismatchBottom) {
        _winningCount++;
        _endTile = upwardTile;
        _tempWinCombos.add(_endTile);
      }else{
        _mismatchBottom = true;
      }
      if(_mismatchTop && _mismatchBottom){
        break;
      }

      if (_winningCount >= setting.k - 1) {
        if(checkOnly){
          return true;
        }
        _hasWinner = true;
        winnerLines = [
          ...winnerLines,
          [_startTile, _endTile]
        ];
        winCombos.addAll(_tempWinCombos);
        winCombos.add(tile);
        break;
      }
    }
    _startTile = tile;
    _endTile = tile;
    _winningCount = 0;
    _tempWinCombos.clear();
    _mismatchTop = false;
    _mismatchBottom = false;

    //check for diagonal lines: Type2
    for (int i = 1; i < setting.k; i++) {
      //check bottom left
      final downwardTile = Tile(tile.x - i, tile.y - i);
      if (_moves[downwardTile] == currentSide && !_mismatchTop) {
        _winningCount++;
        _startTile = downwardTile;
        _tempWinCombos.add(downwardTile);
      }else{
        _mismatchTop = true;
      }

      //check top right
      final upwardTile = Tile(tile.x + i, tile.y + i);
      if (_moves[upwardTile] == currentSide && !_mismatchBottom) {
        _winningCount++;
        _endTile = upwardTile;
        _tempWinCombos.add(_endTile);
      }else{
        _mismatchBottom = true;
      }

      if(_mismatchTop && _mismatchBottom){
        break;
      }

      if (_winningCount >= setting.k - 1) {
        if(checkOnly){
          return true;
        }
        _hasWinner = true;
        winnerLines = [
          ...winnerLines,
          [_startTile, _endTile]
        ];
        winCombos.addAll(_tempWinCombos);
        winCombos.add(tile);
        break;
      }
    }

    return _hasWinner;
  }
}
