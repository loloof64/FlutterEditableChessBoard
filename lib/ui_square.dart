import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:provider/provider.dart';
import 'board.dart';
import 'square.dart';
import 'ui_piece.dart';
import 'ui_tile.dart';

class UISquare extends StatelessWidget {
  final Square square;
  final void Function() onSquareClicked;

  const UISquare({
    Key? key,
    required this.square,
    required this.onSquareClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: square.x,
      top: square.y,
      width: square.size,
      height: square.size,
      child: _buildSquare(context),
    );
  }

  Widget _buildSquare(BuildContext context) {
    final board = Provider.of<Board>(context);
    return InkWell(
      onTap: onSquareClicked,
      child: Stack(
        children: [
          UITile(
            color: square.color,
            size: square.size,
          ),
          board.buildCustomPiece
              .flatMap((t) => Option.fromNullable(t(square)))
              .alt(() => square.piece.map((t) => UIPiece(
                    squareName: square.name,
                    squareColor: square.color,
                    piece: t,
                    size: square.size,
                  )))
              .getOrElse(() => const SizedBox())
        ],
      ),
    );
  }
}
