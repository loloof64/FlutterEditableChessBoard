library editable_chess_board;

import 'package:editable_chess_board/board_color.dart';
import 'package:flutter/material.dart';

import 'rich_chess_board.dart';
import 'selection_zone.dart';
import 'piece.dart';
import 'advanced_options.dart';

/// Texts used for the labels.
class Labels {
  /// Text used for player turn label.
  final String playerTurnLabel;

  /// Text used for white player label.
  final String whitePlayerLabel;

  /// Text used for black player label.
  final String blackPlayerLabel;

  /// Text used for available castles label.
  final String availableCastlesLabel;

  /// Text used for white short castle label.
  final String whiteOOLabel;

  /// Text used for white long label.
  final String whiteOOOLabel;

  /// Text used for black short castle label.
  final String blackOOLabel;

  /// Text used for black long castle label.
  final String blackOOOLabel;

  /// Text used for en passant square label.
  final String enPassantLabel;

  /// Text used for file A label.
  final String fileALabel;

  /// Text used for file B label.
  final String fileBLabel;

  /// Text used for file C label.
  final String fileCLabel;

  /// Text used for file D label.
  final String fileDLabel;

  /// Text used for file E label.
  final String fileELabel;

  /// Text used for file F label.
  final String fileFLabel;

  /// Text used for file G label.
  final String fileGLabel;

  /// Text used for file H label.
  final String fileHLabel;

  /// Text used for rank 3 label.
  final String rank3Label;

  /// Text used for rank 6 label.
  final String rank6Label;

  Labels({
    required this.playerTurnLabel,
    required this.whitePlayerLabel,
    required this.blackPlayerLabel,
    required this.availableCastlesLabel,
    required this.whiteOOLabel,
    required this.whiteOOOLabel,
    required this.blackOOLabel,
    required this.blackOOOLabel,
    required this.enPassantLabel,
    required this.fileALabel,
    required this.fileBLabel,
    required this.fileCLabel,
    required this.fileDLabel,
    required this.fileELabel,
    required this.fileFLabel,
    required this.fileGLabel,
    required this.fileHLabel,
    required this.rank3Label,
    required this.rank6Label,
  });
}

/// Editable chess board widget.
class EditableChessBoard extends StatefulWidget {
  /// Board's position in Forsyth-Edwards Notation.
  final String initialFen;

  // Size of the board.
  final double boardSize;

  // Texts used for the labels.
  final Labels labels;

  /// Constructor.
  const EditableChessBoard({
    Key? key,
    required this.initialFen,
    required this.boardSize,
    required this.labels,
  }) : super(key: key);

  @override
  State<EditableChessBoard> createState() => _EditableChessBoardState();
}

class _EditableChessBoardState extends State<EditableChessBoard> {
  late String _fen;
  Piece? _editingPieceType;

  bool _whiteOO = true;
  bool _whiteOOO = true;
  bool _blackOO = true;
  bool _blackOOO = true;

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

  void _updateCastlesInFen() {
    var parts = _fen.split(' ');
    var newCastlesStr = '';

    if (_whiteOO) newCastlesStr += 'K';
    if (_whiteOOO) newCastlesStr += 'Q';
    if (_blackOO) newCastlesStr += 'k';
    if (_blackOOO) newCastlesStr += 'q';

    if (newCastlesStr.isEmpty) newCastlesStr = '-';

    parts[2] = newCastlesStr;

    setState(() {
      _fen = parts.join(' ');
    });
  }

  void _onWhiteOOChanged(bool? value) {
    if (value != null) {
      setState(() {
        _whiteOO = value;
        _updateCastlesInFen();
      });
    }
  }

  void _onWhiteOOOChanged(bool? value) {
    if (value != null) {
      setState(() {
        _whiteOOO = value;
        _updateCastlesInFen();
      });
    }
  }

  void _onBlackOOChanged(bool? value) {
    if (value != null) {
      setState(() {
        _blackOO = value;
        _updateCastlesInFen();
      });
    }
  }

  void _onBlackOOOChanged(bool? value) {
    if (value != null) {
      setState(() {
        _blackOOO = value;
        _updateCastlesInFen();
      });
    }
  }

  void _onEnPassantChanged(String? value) {
    if (value != null) {
      setState(() {
        //TODO
      });
    }
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
        currentFen: _fen,
        labels: widget.labels,
        whiteOO: _whiteOO,
        whiteOOO: _whiteOOO,
        blackOO: _blackOO,
        blackOOO: _blackOOO,
        onTurnChanged: _onTurnChanged,
        onWhiteOOChanged: _onWhiteOOChanged,
        onWhiteOOOChanged: _onWhiteOOOChanged,
        onBlackOOChanged: _onBlackOOChanged,
        onBlackOOOChanged: _onBlackOOOChanged,
        onEnPassantChanged: _onEnPassantChanged,
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

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}
