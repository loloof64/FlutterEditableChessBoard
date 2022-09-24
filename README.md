A chess board that is not intended to play chess, but just defined a custom chess position and get its code in Forsyth-Edwards Notation (FEN).

## Features

![Preview](https://github.com/loloof64/FlutterEditableChessBoard/blob/main/preview.png)


With this widget, you can :
* set value for each cell with a single click (first select the editing piece type / or the trash)
* clear the board / set to the standard position
* load the widget with a custom position and then reset to this initial position when needed
* get the FEN value / set the board from a FEN value
The board adjusts itself its layout : either portrait or landscape.

Also, you must define all the labels text manually.

## Getting started

* Make sure you give a value to all buttons texts with an instance to the `Labels` class,
* you must create a `PositionController` by passing the initial position to its constructor : the value of
the position in this controller (property `currentPosition`) will be updated with the latest registered position.

## Usage

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = PositionController(
      'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 600.0,
              child: EditableChessBoard(
                boardSize: 400.0,
                controller: _controller,
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
                  submitFieldLabel: 'Validate field',
                  currentPositionLabel: 'Current position: ',
                  copyFenLabel: 'Copy position',
                  pasteFenLabel: 'Paste position',
                  resetPosition: 'Reset position',
                  standardPosition: 'Standard position',
                  erasePosition: 'Erase position',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final isEmptyBoard =
                        _controller.currentPosition.split(' ')[0] ==
                            "8/8/8/8/8/8/8/8";
                    final isValidPosition = !isEmptyBoard &&
                        chess.Chess.validate_fen(
                                _controller.currentPosition)['valid'] ==
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
            )
          ],
        ),
      ),
    );
  }
}

```

## Additional information

[Repository](https://github.com/loloof64/FlutterEditableChessBoard).
