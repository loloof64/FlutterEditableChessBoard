import 'package:flutter/material.dart';
import 'package:editable_chess_board/editable_chess_board.dart';
import 'package:chess/chess.dart' as chess;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Editable chessboard demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editable chessboard demo'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditorPage(
                    title: 'Editor page',
                  ),
                ),
              );
            },
            child: const Text(
              "Enter editor",
            ),
          ),
        ));
  }
}

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.title});

  final String title;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _controller = PositionController(
      'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: deviceSize.height * (isLandscape ? 0.6 : 0.6),
              child: EditableChessBoard(
                boardSize: isLandscape
                    ? deviceSize.width * 0.4
                    : deviceSize.height * 0.4,
                controller: _controller,
                showAdvancedOptions: false,
                labels: Labels(
                  playerTurnLabel: 'Player turn :',
                  whitePlayerLabel: 'White',
                  blackPlayerLabel: 'Black',
                  availableCastlesLabel: 'Available castles :',
                  whiteOOLabel: 'White O-O',
                  whiteOOOLabel: 'White O-O-O',
                  blackOOLabel: 'Black O-O',
                  blackOOOLabel: 'Black O-O-O',
                  enPassantLabel: 'En passant square :',
                  drawHalfMovesCountLabel: 'Draw half moves count : ',
                  moveNumberLabel: 'Move number : ',
                  submitFieldLabel: 'Validate',
                  currentPositionLabel: 'Current position: ',
                  copyFenLabel: 'Copy position',
                  pasteFenLabel: 'Paste position',
                  resetPosition: 'Reset position',
                  standardPosition: 'Standard position',
                  erasePosition: 'Erase position',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final isEmptyBoard =
                        _controller.position.split(' ')[0] == "8/8/8/8/8/8/8/8";
                    final isValidPosition = !isEmptyBoard &&
                        chess.Chess.validate_fen(
                                _controller.position)['valid'] ==
                            true;
                    final message = isValidPosition
                        ? "Valid position"
                        : "Illegal position !";
                    final snackBar = SnackBar(
                      content: Text(message),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Validate position'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
