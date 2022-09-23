library editable_chess_board;

import 'package:flutter/material.dart';
import 'package:super_string/super_string.dart';
import 'package:chess_loloof64/chess_loloof64.dart' as chess;

import 'board_color.dart';
import 'rich_chess_board.dart';
import 'selection_zone.dart';
import 'piece.dart';
import 'advanced_options.dart';
import 'utils.dart';

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

  /// Text used for the draw half moves count.
  final String drawHalfMovesCountLabel;

  /// Text used for the draw half moves count.
  final String moveNumberLabel;

  /// Text used for the submit field value buttons.
  final String submitFieldLabel;

  /// Text used for the current position label.
  final String currentPositionLabel;

  /// Text used for the copy position (into clipboard) label.
  final String copyFenLabel;

  /// Text used for the paste position (from clipboard) label.
  final String pasteFenLabel;

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
    required this.drawHalfMovesCountLabel,
    required this.moveNumberLabel,
    required this.submitFieldLabel,
    required this.currentPositionLabel,
    required this.copyFenLabel,
    required this.pasteFenLabel,
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
    var piecesArray = getPiecesArray(_fen);
    piecesArray[7 - rank][file] = pieceType != null
        ? (pieceType.color == BoardColor.black
            ? pieceType.type.toLowerCase()
            : pieceType.type.toUpperCase())
        : '';

    final newFenBoardPart = piecesArray
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
    _updateEnPassantSquare(fenParts, fenParts[1] == 'w');

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

  void _updateEnPassantSquare(List<String> fenParts, bool whiteTurn) {
    final piecesArray = getPiecesArray(fenParts.join(' '));
    final rank = 7 - (whiteTurn ? 4 : 3);
    final currentEpSquareValue = fenParts[3];
    final expectedPawn = whiteTurn ? 'p' : 'P';
    if (currentEpSquareValue != '-') {
      String pieceAtEpSquare;
      final currentEpFileStr = currentEpSquareValue.charAt(0);
      if (currentEpFileStr == 'a') {
        pieceAtEpSquare = piecesArray[rank][0];
      } else if (currentEpFileStr == 'b') {
        pieceAtEpSquare = piecesArray[rank][1];
      } else if (currentEpFileStr == 'c') {
        pieceAtEpSquare = piecesArray[rank][2];
      } else if (currentEpFileStr == 'd') {
        pieceAtEpSquare = piecesArray[rank][3];
      } else if (currentEpFileStr == 'e') {
        pieceAtEpSquare = piecesArray[rank][4];
      } else if (currentEpFileStr == 'f') {
        pieceAtEpSquare = piecesArray[rank][5];
      } else if (currentEpFileStr == 'g') {
        pieceAtEpSquare = piecesArray[rank][6];
      } else if (currentEpFileStr == 'h') {
        pieceAtEpSquare = piecesArray[rank][7];
      } else {
        pieceAtEpSquare = '';
      }

      if (pieceAtEpSquare == expectedPawn) {
        String currentEpRankStr = currentEpSquareValue.charAt(1);
        int currentEpRank = int.parse(currentEpRankStr);
        int newEpRank = 9 - currentEpRank;
        fenParts[3] = "$currentEpFileStr$newEpRank";
      } else {
        fenParts[3] = '-';
      }
    }
  }

  void _onTurnChanged(bool turn) {
    var parts = _fen.split(' ');
    final newTurnStr = turn ? 'w' : 'b';
    parts[1] = newTurnStr;

    _updateEnPassantSquare(parts, turn);

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
      var parts = _fen.split(' ');
      if (value == '-') {
        parts[3] = value;
      } else {
        final whiteTurn = parts[1] == 'w';
        final rankStr = whiteTurn ? '6' : '3';
        parts[3] = "$value$rankStr";
      }
      setState(() {
        _fen = parts.join(' ');
      });
    }
  }

  void _onHalfMoveCountSubmitted(String value) {
    var parts = _fen.split(' ');
    final newCount = int.tryParse(value);
    if (newCount != null && newCount >= 0) {
      parts[4] = value;
    }

    setState(() {
      _fen = parts.join(' ');
    });
  }

  void _onMoveNumberSubmitted(String value) {
    var parts = _fen.split(' ');
    final newCount = int.tryParse(value);
    if (newCount != null && newCount > 0) {
      parts[5] = value;
    }

    setState(() {
      _fen = parts.join(' ');
    });
  }

  void _onPositionFenSubmitted(String position) {
    final isValidPosition = chess.Chess.validate_fen(position)['valid'] as bool;
    if (isValidPosition) {
      setState(() {
        _fen = position;
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
        onTurnChanged: _onTurnChanged,
        onWhiteOOChanged: _onWhiteOOChanged,
        onWhiteOOOChanged: _onWhiteOOOChanged,
        onBlackOOChanged: _onBlackOOChanged,
        onBlackOOOChanged: _onBlackOOOChanged,
        onEnPassantChanged: _onEnPassantChanged,
        onHalfMoveCountSubmitted: _onHalfMoveCountSubmitted,
        onMoveNumberSubmitted: _onMoveNumberSubmitted,
        onPositionFenSubmitted: _onPositionFenSubmitted,
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
