import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'board.dart';
import 'ui_square.dart';

class ChessBoard extends StatelessWidget {
  final String fen;
  final void Function(int file, int rank) onSquareClicked;

  const ChessBoard({
    super.key,
    required this.fen,
    required this.onSquareClicked,
  });

  Widget _buildPlayerTurn({required double size}) {
    final isWhiteTurn = fen.split(' ')[1] == 'w';
    return Positioned(
      bottom: size * 0.001,
      right: size * 0.001,
      child: _PlayerTurn(size: size * 0.05, whiteTurn: isWhiteTurn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((ctx, constraints) {
        final size = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final boardSize = size * 0.9;
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.indigo.shade300,
              width: size,
              height: size,
              child: Stack(
                children: [
                  ...getFilesCoordinates(
                    boardSize: size,
                    top: true,
                  ),
                  ...getFilesCoordinates(
                    boardSize: size,
                    top: false,
                  ),
                  ...getRanksCoordinates(
                    boardSize: size,
                    left: true,
                  ),
                  ...getRanksCoordinates(
                    boardSize: size,
                    left: false,
                  ),
                  _buildPlayerTurn(size: size),
                ],
              ),
            ),
            _Chessboard(
              fen: fen,
              size: boardSize,
              onSquareClicked: onSquareClicked,
            ),
          ],
        );
      }),
    );
  }
}

class _Chessboard extends StatefulWidget {
  final Board board;
  final void Function(int file, int rank) onSquareClicked;

  _Chessboard({
    required String fen,
    required double size,
    required this.onSquareClicked,
    Color lightSquareColor = const Color.fromRGBO(240, 217, 181, 1),
    Color darkSquareColor = const Color.fromRGBO(181, 136, 99, 1),
    BuildPiece? buildPiece,
    BuildSquare? buildSquare,
    BuildCustomPiece? buildCustomPiece,
  }) : board = Board(
          fen: fen,
          size: size,
          lightSquareColor: lightSquareColor,
          darkSquareColor: darkSquareColor,
          buildPiece: buildPiece,
          buildSquare: buildSquare,
          buildCustomPiece: buildCustomPiece,
        );

  @override
  State<StatefulWidget> createState() => _ChessboardState();
}

class _ChessboardState extends State<_Chessboard> {
  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: widget.board,
      child: SizedBox(
        width: widget.board.size,
        height: widget.board.size,
        child: Stack(
            alignment: AlignmentDirectional.topStart,
            textDirection: TextDirection.ltr,
            children: [
              ...widget.board.squares.map((it) {
                return UISquare(
                  square: it,
                  onSquareClicked: () {
                    final fileStr = it.file;
                    final rankStr = it.rank;

                    final file = fileStr.codeUnitAt(0) - 'a'.codeUnitAt(0);
                    final rank = rankStr.codeUnitAt(0) - '1'.codeUnitAt(0);

                    widget.onSquareClicked(file, rank);
                  },
                );
              }).toList(growable: false),
            ]),
      ),
    );
  }
}

class _PlayerTurn extends StatelessWidget {
  final double size;
  final bool whiteTurn;

  const _PlayerTurn({Key? key, required this.size, required this.whiteTurn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(
        left: 10,
      ),
      decoration: BoxDecoration(
        color: whiteTurn ? Colors.white : Colors.black,
        border: Border.all(
          width: 0.7,
          color: Colors.black,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}

Iterable<Widget> getFilesCoordinates({
  required double boardSize,
  required bool top,
}) {
  final commonTextStyle = TextStyle(
    color: Colors.yellow.shade400,
    fontWeight: FontWeight.bold,
    fontSize: boardSize * 0.04,
  );

  return [0, 1, 2, 3, 4, 5, 6, 7].map(
    (file) {
      final letterOffset = file;
      final letter = String.fromCharCode('A'.codeUnitAt(0) + letterOffset);
      return Positioned(
        top: boardSize * (top ? 0.005 : 0.955),
        left: boardSize * (0.09 + 0.113 * file),
        child: Text(
          letter,
          style: commonTextStyle,
        ),
      );
    },
  );
}

Iterable<Widget> getRanksCoordinates({
  required double boardSize,
  required bool left,
}) {
  final commonTextStyle = TextStyle(
    color: Colors.yellow.shade400,
    fontWeight: FontWeight.bold,
    fontSize: boardSize * 0.04,
  );

  return [0, 1, 2, 3, 4, 5, 6, 7].map((rank) {
    final letterOffset = 7 - rank;
    final letter = String.fromCharCode('1'.codeUnitAt(0) + letterOffset);
    return Positioned(
      left: boardSize * (left ? 0.012 : 0.965),
      top: boardSize * (0.09 + 0.113 * rank),
      child: Text(
        letter,
        style: commonTextStyle,
      ),
    );
  });
}
