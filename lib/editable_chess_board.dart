library editable_chess_board;

import 'package:editable_chess_board/board_color.dart';
import 'package:flutter/material.dart';

import 'rich_chess_board.dart';
import 'selection_zone.dart';
import 'piece.dart';

/// Editable chess board widget.
class EditableChessBoard extends StatefulWidget {
  /// Board's position in Forsyth-Edwards Notation.
  final String initialFen;

  /// Constructor.
  const EditableChessBoard({
    Key? key,
    required this.initialFen,
  }) : super(key: key);

  @override
  State<EditableChessBoard> createState() => _EditableChessBoardState();
}

class _EditableChessBoardState extends State<EditableChessBoard> {
  late String _fen;
  Piece? _editingPieceType;

  @override
  void initState() {
    super.initState();
    _fen = widget.initialFen;
  }

  void _onSquareClicked(int file, int rank) {
    _updateFenPiece(file: file, rank: rank, pieceType: _editingPieceType);
  }

  void _updateFenPiece(
      {required int file, required int rank, required Piece? pieceType}) {
    var fenParts = _fen.split(' ');
    final lines = fenParts[0].split('/');
    var array = lines.map((currentLine) {
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

    final row = 7 - rank;
    final col = file;
    array[row][col] = pieceType != null
        ? (pieceType.color == BoardColor.black
            ? pieceType.type.toLowerCase()
            : pieceType.type.toUpperCase())
        : '';

    final newFenBoardPart = array
        .map((currentLine) {
          var holes = 0;
          var result = "";
          for (var currentElement in currentLine) {
            if (currentElement.isEmpty) {
              holes++;
            } else {
              if (holes > 0) {
                result += "$holes";
              }
              holes = 0;
              result += currentElement;
            }
          }
          if (holes > 0) {
            result += "$holes";
          }

          return result;
        })
        .toList()
        .join("/");

    fenParts[0] = newFenBoardPart;
    final newFen = fenParts.join(" ");

    setState(() {
      _fen = newFen;
    });
  }

  void _onSelection({required Piece type}) {
    setState(() {
      _editingPieceType = type;
    });
  }

  void _onTrashSelection() {
    setState(() {
      _editingPieceType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    const commonWidth = 400.0;
    return Column(
      children: [
        SizedBox(
          width: commonWidth,
          child: ChessBoard(
            fen: _fen,
            onSquareClicked: _onSquareClicked,
          ),
        ),
        WhitePieces(
          width: commonWidth,
          onSelection: _onSelection,
        ),
        BlackPieces(
          width: commonWidth,
          onSelection: _onSelection,
        ),
        TrashAndPreview(
          width: commonWidth,
          selectedPiece: _editingPieceType,
          onTrashSelection: _onTrashSelection,
        )
      ],
    );
  }
}

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}
