import 'package:tictactoe/src/game_internals/enums.dart';

class Tile {
  final int x;
  final int y;

  Tile(this.x, this.y);

  Tile.downwardTile(Tile tile, int displacement,
      {CheckDirection direction = CheckDirection.vertical})
      : this(
            direction == CheckDirection.vertical
                ? tile.x
                : tile.x - displacement,
            direction == CheckDirection.horizontal
                ? tile.y
                : direction == CheckDirection.bottomRightToTopLeft
                    ? tile.y + displacement
                    : tile.y - displacement);

  Tile.upwardTile(Tile tile, int displacement,
      {CheckDirection direction = CheckDirection.vertical})
      : this(
            direction == CheckDirection.vertical
                ? tile.x
                : tile.x + displacement,
            direction == CheckDirection.horizontal
                ? tile.y
                : direction == CheckDirection.bottomRightToTopLeft
                    ? tile.y - displacement
                    : tile.y + displacement);

  @override
  String toString() => 'Tile<$x:$y>';

  @override
  bool operator ==(Object other) {
    return other is Tile && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}
