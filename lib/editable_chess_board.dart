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

  // Size of the board.
  final double boardSize;

  /// Constructor.
  const EditableChessBoard({
    Key? key,
    required this.initialFen,
    required this.boardSize,
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

  void _onTurnChanged(bool turn) {
    var parts = _fen.split(' ');
    final newTurnStr = turn ? 'w' : 'b';
    parts[1] = newTurnStr;

    setState(() {
      _fen = parts.join(' ');
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      Column(
        children: [
          SizedBox(
            width: widget.boardSize,
            child: ChessBoard(
              fen: _fen,
              onSquareClicked: _onSquareClicked,
            ),
          ),
          WhitePieces(
            maxWidth: widget.boardSize,
            onSelection: _onSelection,
          ),
          BlackPieces(
            maxWidth: widget.boardSize,
            onSelection: _onSelection,
          ),
          TrashAndPreview(
            maxWidth: widget.boardSize,
            selectedPiece: _editingPieceType,
            onTrashSelection: _onTrashSelection,
          ),
        ],
      ),
      AdvancedOptions(
        onTurnChanged: _onTurnChanged,
      )
    ];
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      final isPortrait =
          viewportConstraints.maxHeight > viewportConstraints.maxWidth;
      if (isPortrait) {
        return Column(
          children: content,
        );
      } else {
        return Row(
          children: content,
        );
      }
    });
  }
}

class TurnWidgets extends StatefulWidget {
  final void Function(bool turn) onTurnChanged;

  const TurnWidgets({
    Key? key,
    required this.onTurnChanged,
  }) : super(key: key);

  @override
  State<TurnWidgets> createState() => _TurnWidgetsState();
}

class _TurnWidgetsState extends State<TurnWidgets> {
  bool _isWhiteTurn = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Player turn',
        ),
        ListTile(
          title: const Text('White'),
          leading: Radio<bool>(
            groupValue: _isWhiteTurn,
            value: true,
            onChanged: (value) {
              setState(() {
                _isWhiteTurn = value ?? true;
                widget.onTurnChanged(_isWhiteTurn);
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Black'),
          leading: Radio<bool>(
            groupValue: _isWhiteTurn,
            value: false,
            onChanged: (value) {
              setState(() {
                _isWhiteTurn = value ?? false;
                widget.onTurnChanged(_isWhiteTurn);
              });
            },
          ),
        ),
      ],
    );
  }
}

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}

class AdvancedOptions extends StatefulWidget {
  final void Function(bool value) onTurnChanged;
  const AdvancedOptions({super.key, required this.onTurnChanged});

  @override
  State<AdvancedOptions> createState() => _AdvancedOptionsState();
}

class _AdvancedOptionsState extends State<AdvancedOptions> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TurnWidgets(
              onTurnChanged: widget.onTurnChanged,
            ),
          ],
        ),
      ),
    );
  }
}
