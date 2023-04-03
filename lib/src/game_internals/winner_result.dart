class WinnerResult{
  final List winnerLines;
  final List winnerCombos;

  WinnerResult(this.winnerLines, this.winnerCombos);


  @override
  String toString() => 'WinnerResult<$winnerLines:$winnerCombos>';

  @override
  bool operator ==(Object other) {
    return other is WinnerResult && other.winnerLines == winnerLines && other.winnerCombos == winnerCombos;
  }

  @override
  int get hashCode => Object.hash(winnerLines, winnerCombos);

}