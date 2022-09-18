import 'package:flutter/material.dart';

import 'package:editable_chess_board/piece_type.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'piece.dart';
import 'board_color.dart';

class WhitePieces extends StatelessWidget {
  final double width;
  final void Function({required Piece type}) onSelection;

  const WhitePieces({required this.width, required this.onSelection});

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

  const BlackPieces({required this.width, required this.onSelection});

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
