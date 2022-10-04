import 'package:chess/chess.dart' as ch;
import 'package:fpdart/fpdart.dart';

import 'board.dart';
import 'board_color.dart';
import 'piece.dart';
import 'piece_type.dart';
import 'square.dart';

List<Square> getSquares(Board board) {
  final chess = ch.Chess.fromFEN(board.fen, check_validity: false);
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

List<List<String>> getPiecesArray(String fen) {
  var fenParts = fen.split(' ');
  final lines = fenParts[0].split('/');
  var piecesArray = lines.map((currentLine) {
    var arrayLine = <String>[];
    final elements = currentLine.split('');
    for (var currentElement in elements) {
      if (currentElement.isNumeric) {
        final holesCount = currentElement.codeUnitAt(0) - '0'.codeUnitAt(0);
        for (int j = 0; j < holesCount; j++) {
          arrayLine.add('');
        }
      } else {
        arrayLine.add(currentElement);
      }
    }
    return arrayLine;
  }).toList();

  return piecesArray;
}

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}
