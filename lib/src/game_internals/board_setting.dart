import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/game_internals/enums.dart';

class BoardSetting {
  final int m;

  final int n;

  final int k;
  final int? gameId;

  final Side playerSide;

  final bool opponentStarts;

  final AiOpponent? aiOpponent;

  bool get isAiPlaying => aiOpponent != null;

  const BoardSetting(this.m, this.n, this.k,
      {bool playerIsX = true,
      this.opponentStarts = false,
      this.gameId,
      this.aiOpponent})
      : this.playerSide = playerIsX ? Side.X : Side.O;

  const BoardSetting.defaultBoard() : this(3, 3, 3);

  Side get opponentSide => playerSide == Side.X ? Side.O : Side.X;

  BoardSetting update(
      {int? m,
      int? n,
      int? k,
      int? gameId,
      bool? playerIsX,
      bool? opponentStarts,
      AiOpponent? aiOpponent}) {
    return BoardSetting(m ?? this.m, n ?? this.n, k ?? this.k,
        gameId: gameId ?? this.gameId,
        opponentStarts: opponentStarts ?? this.opponentStarts,
        aiOpponent: aiOpponent ?? this.aiOpponent,
        playerIsX: playerIsX ?? (this.playerSide == Side.X));
  }

  @override
  bool operator ==(Object other) {
    return other is BoardSetting &&
        other.m == m &&
        other.n == n &&
        other.opponentStarts == opponentStarts &&
        other.playerSide == playerSide &&
        other.gameId == gameId;
  }

  @override
  int get hashCode => Object.hash(m, n, k, opponentStarts, playerSide, gameId);
}
