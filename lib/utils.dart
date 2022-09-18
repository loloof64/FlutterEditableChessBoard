import 'package:chess/chess.dart' as ch;
import 'package:fpdart/fpdart.dart';

import 'board.dart';
import 'board_color.dart';
import 'piece.dart';
import 'piece_type.dart';
import 'square.dart';

List<Square> getSquares(Board board) {
  final chess = ch.Chess.fromFEN(board.fen);
  return ch.Chess.SQUARES.keys.map((squareName) {
    return Square(
      board: board,
      name: squareName,
      piece: Option.fromNullable(chess.get(squareName)).map(
        (t) => Piece(
          t.color == ch.Color.WHITE ? BoardColor.white : BoardColor.black,
          PieceType.fromString(t.type.toString()),
        ),
      ),
    );
  }).toList(growable: false);
}

Future<PieceType?> defaultPromoting() => Future.value(PieceType.queen);
