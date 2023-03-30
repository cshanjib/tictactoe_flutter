class Tile{
  final int x;
  final int y;

  Tile(this.x, this.y);


  @override
  String toString() => 'Tile<$x:$y>';

  @override
  bool operator ==(Object other) {
    return other is Tile && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

}