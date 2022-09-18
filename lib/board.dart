import 'package:flutter/material.dart';
import 'piece.dart';
import 'utils.dart' as utils;
import 'package:fpdart/fpdart.dart';

import 'board_color.dart';
import 'square.dart';

typedef BuildPiece = Widget? Function(Piece piece, double size);
typedef BuildSquare = Widget? Function(BoardColor color, double size);
typedef BuildCustomPiece = Widget? Function(Square square);

class Board {
  final String fen;
  final double size;
  final Color lightSquareColor;
  final Color darkSquareColor;
  final Option<BuildPiece> buildPiece;
  final Option<BuildSquare> buildSquare;
  final Option<BuildCustomPiece> buildCustomPiece;

  Board({
    required this.fen,
    required this.size,
    required this.lightSquareColor,
    required this.darkSquareColor,
    BuildPiece? buildPiece,
    BuildSquare? buildSquare,
    BuildCustomPiece? buildCustomPiece,
  })  : buildPiece = Option.fromNullable(buildPiece),
        buildSquare = Option.fromNullable(buildSquare),
        buildCustomPiece = Option.fromNullable(buildCustomPiece);

  double get squareSize => size / 8;

  List<Square> get squares => utils.getSquares(this);
}
