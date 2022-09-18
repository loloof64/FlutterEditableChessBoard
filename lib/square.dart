import 'board_color.dart';
import 'package:fpdart/fpdart.dart';

import 'board.dart';
import 'piece.dart';

class Square {
  final Board board;
  final String name;
  final Option<Piece> piece;

  Square({
    required this.board,
    required this.name,
    required this.piece,
  });

  int get xAxis {
    final i = file.codeUnitAt(0) - 97;
    return i;
  }

  int get yAxis {
    final i = int.parse(rank) - 1;
    return 7 - i;
  }

  double get x => xAxis * size;

  double get y => yAxis * size;

  String get file => name.substring(0, 1);

  String get rank => name.substring(1);

  BoardColor get color {
    return (xAxis + yAxis) % 2 == 0 ? BoardColor.white : BoardColor.black;
  }

  double get size => board.squareSize;
}
