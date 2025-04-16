import 'package:flutter/material.dart';

import 'package:editable_chess_board/piece_type.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'piece.dart';
import 'board_color.dart';

class SelectionZone extends StatelessWidget {
  final bool whitePieces;
  final Piece? selectedPiece;
  final void Function({required Piece type}) onSelection;
  final void Function() onTrashSelection;
  final void Function() onColorToggle;

  const SelectionZone({
    super.key,
    required this.whitePieces,
    required this.selectedPiece,
    required this.onSelection,
    required this.onTrashSelection,
    required this.onColorToggle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth =
          constraints.maxWidth > 500 ? 500 : constraints.maxWidth;
      final singlePieceWidth = totalWidth * 0.06;
      return Container(
        color: Colors.blueGrey.shade700,
        child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onColorToggle,
                child: ColorToggler(
                  whitePiecesSelected: whitePieces,
                  commonSize: singlePieceWidth,
                ),
              ),
              PiecePreview(
                piece: selectedPiece,
                size: singlePieceWidth,
              ),
              InkWell(
                onTap: () => onSelection(
                  type: Piece(
                    whitePieces ? BoardColor.white : BoardColor.black,
                    PieceType.pawn,
                  ),
                ),
                child: whitePieces
                    ? WhitePawn(size: singlePieceWidth)
                    : BlackPawn(size: singlePieceWidth),
              ),
              InkWell(
                onTap: () => onSelection(
                  type: Piece(
                    whitePieces ? BoardColor.white : BoardColor.black,
                    PieceType.knight,
                  ),
                ),
                child: whitePieces
                    ? WhiteKnight(size: singlePieceWidth)
                    : BlackKnight(size: singlePieceWidth),
              ),
              InkWell(
                onTap: () => onSelection(
                  type: Piece(
                    whitePieces ? BoardColor.white : BoardColor.black,
                    PieceType.bishop,
                  ),
                ),
                child: whitePieces
                    ? WhiteBishop(size: singlePieceWidth)
                    : BlackBishop(size: singlePieceWidth),
              ),
              InkWell(
                onTap: () => onSelection(
                  type: Piece(
                    whitePieces ? BoardColor.white : BoardColor.black,
                    PieceType.rook,
                  ),
                ),
                child: whitePieces
                    ? WhiteRook(size: singlePieceWidth)
                    : BlackRook(size: singlePieceWidth),
              ),
              InkWell(
                onTap: () => onSelection(
                  type: Piece(
                    whitePieces ? BoardColor.white : BoardColor.black,
                    PieceType.queen,
                  ),
                ),
                child: whitePieces
                    ? WhiteQueen(size: singlePieceWidth)
                    : BlackQueen(size: singlePieceWidth),
              ),
              InkWell(
                onTap: () => onSelection(
                  type: Piece(
                    whitePieces ? BoardColor.white : BoardColor.black,
                    PieceType.king,
                  ),
                ),
                child: whitePieces
                    ? WhiteKing(size: singlePieceWidth)
                    : BlackKing(size: singlePieceWidth),
              ),
              InkWell(
                onTap: onTrashSelection,
                child: Icon(
                  Icons.delete,
                  size: singlePieceWidth,
                  color: Colors.red,
                ),
              ),
            ]),
      );
    });
  }
}

class PiecePreview extends StatelessWidget {
  final Piece? piece;
  final double size;

  const PiecePreview({
    Key? key,
    required this.piece,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pieceWidget = buildPiece(piece, size);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black),
      ),
      width: size * 0.9,
      height: size * 0.9,
      child: pieceWidget,
    );
  }

  Widget buildPiece(Piece? piece, double size) {
    if (piece == Piece.whiteRook) {
      return WhiteRook(size: size);
    } else if (piece == Piece.whiteKnight) {
      return WhiteKnight(size: size);
    } else if (piece == Piece.whiteBishop) {
      return WhiteBishop(size: size);
    } else if (piece == Piece.whiteKing) {
      return WhiteKing(size: size);
    } else if (piece == Piece.whiteQueen) {
      return WhiteQueen(size: size);
    } else if (piece == Piece.whitePawn) {
      return WhitePawn(size: size);
    } else if (piece == Piece.blackRook) {
      return BlackRook(size: size);
    } else if (piece == Piece.blackKnight) {
      return BlackKnight(size: size);
    } else if (piece == Piece.blackBishop) {
      return BlackBishop(size: size);
    } else if (piece == Piece.blackKing) {
      return BlackKing(size: size);
    } else if (piece == Piece.blackQueen) {
      return BlackQueen(size: size);
    } else if (piece == Piece.blackPawn) {
      return BlackPawn(size: size);
    } else {
      return Center(
        child: FaIcon(
          FontAwesomeIcons.trash,
          size: size * 0.7,
          color: Colors.red,
        ),
      );
    }
  }
}

class ColorToggler extends StatelessWidget {
  final bool whitePiecesSelected;
  final double commonSize;

  const ColorToggler({
    super.key,
    required this.whitePiecesSelected,
    required this.commonSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: commonSize,
      height: commonSize,
      color: whitePiecesSelected ? Colors.black : Colors.white,
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.arrowsUpDown,
          size: commonSize * 0.7,
          color: whitePiecesSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
