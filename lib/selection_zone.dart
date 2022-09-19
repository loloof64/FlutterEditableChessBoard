import 'package:flutter/material.dart';

import 'package:editable_chess_board/piece_type.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'piece.dart';
import 'board_color.dart';

class WhitePieces extends StatelessWidget {
  final double width;
  final void Function({required Piece type}) onSelection;

  const WhitePieces(
      {super.key, required this.width, required this.onSelection});

  @override
  Widget build(BuildContext context) {
    final commonSize = width * 0.1;
    return Container(
      decoration: const BoxDecoration(color: Colors.grey),
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: WhitePawn(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.white,
                PieceType.pawn,
              ),
            ),
          ),
          InkWell(
            child: WhiteKnight(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.white,
                PieceType.knight,
              ),
            ),
          ),
          InkWell(
            child: WhiteBishop(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.white,
                PieceType.bishop,
              ),
            ),
          ),
          InkWell(
            child: WhiteRook(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.white,
                PieceType.rook,
              ),
            ),
          ),
          InkWell(
            child: WhiteQueen(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.white,
                PieceType.queen,
              ),
            ),
          ),
          InkWell(
            child: WhiteKing(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.white,
                PieceType.king,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BlackPieces extends StatelessWidget {
  final double width;
  final void Function({required Piece type}) onSelection;

  const BlackPieces(
      {super.key, required this.width, required this.onSelection});

  @override
  Widget build(BuildContext context) {
    final commonSize = width * 0.1;
    return Container(
      decoration: const BoxDecoration(color: Colors.grey),
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: BlackPawn(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.black,
                PieceType.pawn,
              ),
            ),
          ),
          InkWell(
            child: BlackKnight(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.black,
                PieceType.knight,
              ),
            ),
          ),
          InkWell(
            child: BlackBishop(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.black,
                PieceType.bishop,
              ),
            ),
          ),
          InkWell(
            child: BlackRook(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.black,
                PieceType.rook,
              ),
            ),
          ),
          InkWell(
            child: BlackQueen(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.black,
                PieceType.queen,
              ),
            ),
          ),
          InkWell(
            child: BlackKing(
              size: commonSize,
            ),
            onTap: () => onSelection(
              type: const Piece(
                BoardColor.black,
                PieceType.king,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TrashAndPreview extends StatelessWidget {
  final double width;
  final Piece? selectedPiece;
  final void Function() onTrashSelection;

  const TrashAndPreview({
    super.key,
    required this.width,
    required this.selectedPiece,
    required this.onTrashSelection,
  });

  @override
  Widget build(BuildContext context) {
    final commonSize = width * 0.1;
    return Container(
      color: Colors.grey,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: commonSize,
            height: commonSize,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
            child: PiecePreview(
              piece: selectedPiece,
              size: commonSize,
            ),
          ),
          InkWell(
            onTap: onTrashSelection,
            child: Icon(
              Icons.delete,
              size: commonSize,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
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

    return pieceWidget;
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
      return const SizedBox();
    }
  }
}
