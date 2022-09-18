library editable_chess_board;

import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:editable_chess_board/board_color.dart';
import 'package:editable_chess_board/piece_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'board.dart';
import 'ui_square.dart';
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
        _WhitePieces(
          width: commonWidth,
          onSelection: _onSelection,
        ),
        _BlackPieces(
          width: commonWidth,
          onSelection: _onSelection,
        ),
      ],
    );
  }
}

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

class _WhitePieces extends StatelessWidget {
  final double width;
  final void Function({required Piece type}) onSelection;

  const _WhitePieces({required this.width, required this.onSelection});

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

class _BlackPieces extends StatelessWidget {
  final double width;
  final void Function({required Piece type}) onSelection;

  const _BlackPieces({required this.width, required this.onSelection});

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

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}
