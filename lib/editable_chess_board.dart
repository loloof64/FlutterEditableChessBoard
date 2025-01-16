library editable_chess_board;

import 'package:editable_chess_board/store/editing_store.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:super_string/super_string.dart';
import 'package:chess/chess.dart' as chess;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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

  /// Text used for loading position that was first used when showing this widget button label.
  final String resetPosition;

  /// Text used for loading standard position button label.
  final String standardPosition;

  /// Text used for erasing position button label.
  final String erasePosition;

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
    required this.resetPosition,
    required this.standardPosition,
    required this.erasePosition,
  });
}

/// A controller for the position value of the editable chess board.
///
/// Whenever the position of the editable board is updated, the controller gets
/// updated with the new value, and the controller notifies its listeners.
class PositionController {
  String position;

  /// Constructor with board's initial position in Forsyth-Edwards Notation.
  PositionController(this.position);
}

/// Editable chess board widget.
class EditableChessBoard extends StatefulWidget {
  // Size of the board.
  final double boardSize;

  // Texts used for the labels.
  final Labels labels;

  /// A controller for the position value of this editable chess board.
  final PositionController controller;

  /// Constructor.
  const EditableChessBoard({
    Key? key,
    required this.boardSize,
    required this.labels,
    required this.controller,
  }) : super(key: key);

  @override
  State<EditableChessBoard> createState() => _EditableChessBoardState();
}

class _EditableChessBoardState extends State<EditableChessBoard> {
  late String _initialFen;

  @override
  void initState() {
    super.initState();
    GetIt.instance.registerSingleton<EditingStore>(EditingStore());
    final editingStore = GetIt.instance.get<EditingStore>();
    _initialFen = widget.controller.position;
    editingStore.setFen(_initialFen);
  }

  @override
  void dispose() {
    GetIt.instance.unregister<EditingStore>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editingStore = GetIt.instance.get<EditingStore>();
    final content = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: widget.boardSize,
          height: widget.boardSize,
          child: ReactionBuilder(
            builder: (context) {
              return reaction((_) => editingStore.fen, (newFen) {
                widget.controller.position = newFen;
              });
            },
            child: Observer(builder: (_) {
              return ChessBoard(
                fen: editingStore.fen,
                onSquareClicked: _onSquareClicked,
              );
            }),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ReactionBuilder(
            builder: (context) {
              return reaction((_) => editingStore.fen, (newFen) {
                widget.controller.position = newFen;
              });
            },
            child: Options(
              initialFen: _initialFen,
              labels: widget.labels,
            ),
          ),
        ),
      )
    ];

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: content,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: content,
          );
  }

  void _onSquareClicked(int file, int rank) {
    final editingStore = GetIt.instance.get<EditingStore>();

    _updateFenPiece(
      file: file,
      rank: rank,
      pieceType: editingStore.editingPiece,
    );
  }

  void _updateFenPiece(
      {required int file, required int rank, required Piece? pieceType}) {
    final editingStore = GetIt.instance.get<EditingStore>();
    final fen = editingStore.fen;
    var fenParts = fen.split(' ');
    var piecesArray = getPiecesArray(fen);
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
    editingStore.setFen(newFen);
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
}

class Options extends StatefulWidget {
  final String initialFen;
  final Labels labels;

  const Options({
    super.key,
    required this.initialFen,
    required this.labels,
  });

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options>
    with SingleTickerProviderStateMixin, ChangeNotifier {
  bool _whiteOO = true;
  bool _whiteOOO = true;
  bool _blackOO = true;
  bool _blackOOO = true;

  late TabController _tabController;

  late TextEditingController _positionEditTextController;

  @override
  void initState() {
    super.initState();
    _positionEditTextController =
        TextEditingController(text: widget.initialFen);
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _positionEditTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editingStore = GetIt.instance.get<EditingStore>();

    return Column(
      children: [
        Observer(builder: (_) {
          return Text(editingStore.fen);
        }),
        TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(
              child: FaIcon(
                FontAwesomeIcons.puzzlePiece,
                color: Colors.orange,
              ),
            ),
            Tab(
              child: Icon(
                FontAwesomeIcons.arrowsLeftRight,
                color: Colors.green,
              ),
            ),
            Tab(
              child: Icon(
                FontAwesomeIcons.fortAwesome,
                color: Colors.blue,
              ),
            ),
            Tab(
              child: Icon(
                FontAwesomeIcons.question,
                color: Colors.red,
              ),
            ),
            Tab(
              child: Icon(
                FontAwesomeIcons.bookmark,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Observer(builder: (_) {
              return TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: WhitePieces(
                          maxWidth: double.infinity,
                          onSelection: _onSelection,
                        ),
                      ),
                      Flexible(
                        child: BlackPieces(
                          maxWidth: double.infinity,
                          onSelection: _onSelection,
                        ),
                      ),
                      Flexible(
                        child: TrashAndPreview(
                          maxWidth: double.infinity,
                          selectedPiece: editingStore.editingPiece,
                          onTrashSelection: _onTrashSelection,
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: TurnWidget(
                      labels: widget.labels,
                      currentFen: editingStore.fen,
                      onTurnChanged: _onTurnChanged,
                    ),
                  ),
                  SingleChildScrollView(
                    child: CastlesWidget(
                      labels: widget.labels,
                      whiteOO: editingStore.fen.split(' ')[2].contains('K'),
                      whiteOOO: editingStore.fen.split(' ')[2].contains('Q'),
                      blackOO: editingStore.fen.split(' ')[2].contains('k'),
                      blackOOO: editingStore.fen.split(' ')[2].contains('q'),
                      onWhiteOOChanged: _onWhiteOOChanged,
                      onWhiteOOOChanged: _onWhiteOOOChanged,
                      onBlackOOChanged: _onBlackOOChanged,
                      onBlackOOOChanged: _onBlackOOOChanged,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EnPassantWidget(
                          currentFen: editingStore.fen,
                          labels: widget.labels,
                          onChanged: _onEnPassantChanged,
                        ),
                        DrawHalfMovesCountWidget(
                          currentFen: editingStore.fen,
                          labels: widget.labels,
                          onSubmitted: _onHalfMoveCountSubmitted,
                        ),
                        MoveNumberWidget(
                          currentFen: editingStore.fen,
                          labels: widget.labels,
                          onSubmitted: _onMoveNumberSubmitted,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: FenControlsWidget(
                      initialFen: widget.initialFen,
                      currentFen: editingStore.fen,
                      labels: widget.labels,
                      onPositionFenSubmitted: _onPositionFenSubmitted,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  void _onSelection({required Piece type}) {
    final editingStore = GetIt.instance.get<EditingStore>();
    editingStore.setEditingPiece(type);
  }

  void _onTrashSelection() {
    final editingStore = GetIt.instance.get<EditingStore>();
    editingStore.setEditingPiece(null);
  }

  void _onPositionFenSubmitted(String position) {
    final isValidPosition = chess.Chess.validate_fen(position)['valid'] as bool;
    if (isValidPosition) {
      final editingStore = GetIt.instance.get<EditingStore>();
      editingStore.setFen(position);
    }
  }

  void _onTurnChanged(bool turn) {
    final editingStore = GetIt.instance.get<EditingStore>();
    var parts = editingStore.fen.split(' ');
    final newTurnStr = turn ? 'w' : 'b';
    parts[1] = newTurnStr;

    _updateEnPassantSquare(parts, turn);

    editingStore.setFen(parts.join(' '));
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

      _onEnPassantChanged(fenParts[3]);
    }
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

  void _updateCastlesInFen() {
    final editingStore = GetIt.instance.get<EditingStore>();
    var parts = editingStore.fen.split(' ');
    var newCastlesStr = '';

    if (_whiteOO) newCastlesStr += 'K';
    if (_whiteOOO) newCastlesStr += 'Q';
    if (_blackOO) newCastlesStr += 'k';
    if (_blackOOO) newCastlesStr += 'q';

    if (newCastlesStr.isEmpty) newCastlesStr = '-';

    parts[2] = newCastlesStr;

    editingStore.setFen(parts.join(' '));
  }

  void _onEnPassantChanged(String? value) {
    //////////////////////////////////////
    print("En passant : $value");
    //////////////////////////////////////
    if (value != null) {
      final editingStore = GetIt.instance.get<EditingStore>();
      var parts = editingStore.fen.split(' ');
      if (value == '-') {
        parts[3] = value;
      } else {
        final whiteTurn = parts[1] == 'w';
        final rankStr = whiteTurn ? '6' : '3';
        parts[3] = "$value$rankStr";
      }

      editingStore.setFen(parts.join(' '));
    }
  }

  void _onHalfMoveCountSubmitted(String value) {
    final editingStore = GetIt.instance.get<EditingStore>();
    var parts = editingStore.fen.split(' ');
    final newCount = int.tryParse(value);
    if (newCount != null && newCount >= 0) {
      parts[4] = value;
    }

    editingStore.setFen(parts.join(' '));
  }

  void _onMoveNumberSubmitted(String value) {
    final editingStore = GetIt.instance.get<EditingStore>();
    var parts = editingStore.fen.split(' ');
    final newCount = int.tryParse(value);
    if (newCount != null && newCount > 0) {
      parts[5] = value;
    }

    editingStore.setFen(parts.join(' '));
  }
}
