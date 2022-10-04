import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:super_string/super_string.dart';
import 'package:chess/chess.dart' as chess;
import 'editable_chess_board.dart';
import 'utils.dart';

class StringHolder {
  String value;

  StringHolder(this.value);
}

class AdvancedOptions extends StatefulWidget {
  final String initialFen;
  final String currentFen;
  final Labels labels;

  final void Function(bool value) onTurnChanged;
  final void Function(bool?) onWhiteOOChanged;
  final void Function(bool?) onWhiteOOOChanged;
  final void Function(bool?) onBlackOOChanged;
  final void Function(bool?) onBlackOOOChanged;
  final void Function(String?) onEnPassantChanged;
  final void Function(String) onHalfMoveCountSubmitted;
  final void Function(String) onMoveNumberSubmitted;
  final void Function(String) onPositionFenSubmitted;

  const AdvancedOptions({
    super.key,
    required this.currentFen,
    required this.initialFen,
    required this.labels,
    required this.onTurnChanged,
    required this.onWhiteOOChanged,
    required this.onWhiteOOOChanged,
    required this.onBlackOOChanged,
    required this.onBlackOOOChanged,
    required this.onEnPassantChanged,
    required this.onHalfMoveCountSubmitted,
    required this.onMoveNumberSubmitted,
    required this.onPositionFenSubmitted,
  });

  @override
  State<AdvancedOptions> createState() => _AdvancedOptionsState();
}

class _AdvancedOptionsState extends State<AdvancedOptions> {
  @override
  Widget build(BuildContext context) {
    final fenParts = widget.currentFen.split(' ');
    final castlesPart = fenParts[2];
    final whiteOO = castlesPart.contains('K');
    final whiteOOO = castlesPart.contains('Q');
    final blackOO = castlesPart.contains('k');
    final blackOOO = castlesPart.contains('q');

    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FenControlsWidget(
              initialFen: widget.initialFen,
              currentFen: widget.currentFen,
              labels: widget.labels,
              onPositionFenSubmitted: widget.onPositionFenSubmitted,
            ),
            const Divider(
              color: Colors.black,
            ),
            TurnWidget(
              labels: widget.labels,
              currentFen: widget.currentFen,
              onTurnChanged: widget.onTurnChanged,
            ),
            const Divider(
              color: Colors.black,
            ),
            CastlesWidget(
              labels: widget.labels,
              whiteOO: whiteOO,
              whiteOOO: whiteOOO,
              blackOO: blackOO,
              blackOOO: blackOOO,
              onWhiteOOChanged: widget.onWhiteOOChanged,
              onWhiteOOOChanged: widget.onWhiteOOOChanged,
              onBlackOOChanged: widget.onBlackOOChanged,
              onBlackOOOChanged: widget.onBlackOOOChanged,
            ),
            const Divider(
              color: Colors.black,
            ),
            EnPassantWidget(
              currentFen: widget.currentFen,
              labels: widget.labels,
              onChanged: widget.onEnPassantChanged,
            ),
            const Divider(
              color: Colors.black,
            ),
            DrawHalfMovesCountWidget(
              currentFen: widget.currentFen,
              labels: widget.labels,
              onSubmitted: widget.onHalfMoveCountSubmitted,
            ),
            const Divider(
              color: Colors.black,
            ),
            MoveNumberWidget(
              currentFen: widget.currentFen,
              labels: widget.labels,
              onSubmitted: widget.onMoveNumberSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}

class TurnWidget extends StatelessWidget {
  final Labels labels;
  final String currentFen;
  final void Function(bool turn) onTurnChanged;

  const TurnWidget({
    Key? key,
    required this.labels,
    required this.currentFen,
    required this.onTurnChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWhiteTurn = currentFen.split(' ')[1] == 'w';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labels.playerTurnLabel,
        ),
        ListTile(
          title: Text(labels.whitePlayerLabel),
          leading: Radio<bool>(
            groupValue: isWhiteTurn,
            value: true,
            onChanged: (value) {
              onTurnChanged(value ?? true);
            },
          ),
        ),
        ListTile(
          title: Text(labels.blackPlayerLabel),
          leading: Radio<bool>(
            groupValue: isWhiteTurn,
            value: false,
            onChanged: (value) {
              onTurnChanged(value ?? false);
            },
          ),
        ),
      ],
    );
  }
}

class CastlesWidget extends StatelessWidget {
  final Labels labels;
  final bool whiteOO;
  final bool whiteOOO;
  final bool blackOO;
  final bool blackOOO;

  final void Function(bool?) onWhiteOOChanged;
  final void Function(bool?) onWhiteOOOChanged;
  final void Function(bool?) onBlackOOChanged;
  final void Function(bool?) onBlackOOOChanged;

  const CastlesWidget({
    super.key,
    required this.labels,
    required this.whiteOO,
    required this.whiteOOO,
    required this.blackOO,
    required this.blackOOO,
    required this.onWhiteOOChanged,
    required this.onWhiteOOOChanged,
    required this.onBlackOOChanged,
    required this.onBlackOOOChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labels.availableCastlesLabel),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(labels.whiteOOLabel),
            Checkbox(value: whiteOO, onChanged: onWhiteOOChanged),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(labels.whiteOOOLabel),
            Checkbox(value: whiteOOO, onChanged: onWhiteOOOChanged),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(labels.blackOOLabel),
            Checkbox(value: blackOO, onChanged: onBlackOOChanged),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(labels.blackOOOLabel),
            Checkbox(value: blackOOO, onChanged: onBlackOOOChanged),
          ],
        ),
      ],
    );
  }
}

class EnPassantWidget extends StatelessWidget {
  final String currentFen;
  final Labels labels;
  final void Function(String?) onChanged;

  final List<String> items = <String>[
    '-',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
  ];
  final StringHolder dropdownValue = StringHolder('');

  EnPassantWidget({
    super.key,
    required this.currentFen,
    required this.labels,
    required this.onChanged,
  }) {
    dropdownValue.value = currentFen.split(' ')[3].charAt(0);
  }

  bool _checkCorrectDropdown(String value) {
    final whiteTurn = currentFen.split(' ')[1] == 'w';
    final rank = 7 - (whiteTurn ? 4 : 3);
    final expectedPawnValue = whiteTurn ? 'p' : 'P';
    final piecesArray = getPiecesArray(currentFen);

    if (value == items.first) return true;
    if (value == 'a') {
      return piecesArray[rank][0] == expectedPawnValue;
    }
    if (value == 'b') {
      return piecesArray[rank][1] == expectedPawnValue;
    }
    if (value == 'c') {
      return piecesArray[rank][2] == expectedPawnValue;
    }
    if (value == 'd') {
      return piecesArray[rank][3] == expectedPawnValue;
    }
    if (value == 'e') {
      return piecesArray[rank][4] == expectedPawnValue;
    }
    if (value == 'f') {
      return piecesArray[rank][5] == expectedPawnValue;
    }
    if (value == 'g') {
      return piecesArray[rank][6] == expectedPawnValue;
    }
    if (value == 'h') {
      return piecesArray[rank][7] == expectedPawnValue;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final whiteTurn = currentFen.split(' ')[1] == 'w';

    if (!_checkCorrectDropdown(dropdownValue.value)) {
      dropdownValue.value = items.first;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(labels.enPassantLabel),
        DropdownButton<String>(
          value: dropdownValue.value,
          items: items
              .map(
                (currentItem) => DropdownMenuItem<String>(
                  value: currentItem,
                  child: Text(currentItem),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              final isCorrectDropdown = _checkCorrectDropdown(value);
              if (isCorrectDropdown) {
                dropdownValue.value = value;
                onChanged(value);
              }
            }
          },
        ),
        Text(dropdownValue.value != items.first ? (whiteTurn ? '6' : '3') : ''),
      ],
    );
  }
}

class DrawHalfMovesCountWidget extends StatelessWidget {
  final String currentFen;
  final Labels labels;
  final void Function(String) onSubmitted;

  final TextEditingController _fieldController =
      TextEditingController(text: '');

  DrawHalfMovesCountWidget({
    super.key,
    required this.currentFen,
    required this.labels,
    required this.onSubmitted,
  }) {
    final String currentCount = currentFen.split(' ')[4];
    _fieldController.text = currentCount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              labels.drawHalfMovesCountLabel,
            ),
            Expanded(
              child: TextField(
                controller: _fieldController,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => onSubmitted(_fieldController.text),
          child: Text(
            labels.submitFieldLabel,
          ),
        )
      ],
    );
  }
}

class MoveNumberWidget extends StatelessWidget {
  final String currentFen;
  final Labels labels;
  final void Function(String) onSubmitted;

  final TextEditingController _fieldController =
      TextEditingController(text: '');

  MoveNumberWidget({
    super.key,
    required this.currentFen,
    required this.labels,
    required this.onSubmitted,
  }) {
    final String currentCount = currentFen.split(' ')[5];
    _fieldController.text = currentCount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              labels.moveNumberLabel,
            ),
            Expanded(
              child: TextField(
                controller: _fieldController,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => onSubmitted(_fieldController.text),
          child: Text(
            labels.submitFieldLabel,
          ),
        )
      ],
    );
  }
}

class FenControlsWidget extends StatelessWidget {
  final Labels labels;
  final String currentFen;
  final String initialFen;
  final void Function(String) onPositionFenSubmitted;

  final TextEditingController _positionFenController =
      TextEditingController(text: '');

  FenControlsWidget({
    super.key,
    required this.labels,
    required this.currentFen,
    required this.initialFen,
    required this.onPositionFenSubmitted,
  }) {
    _positionFenController.text = currentFen;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(labels.currentPositionLabel),
            Expanded(
              child: TextField(
                controller: _positionFenController,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () =>
                onPositionFenSubmitted(_positionFenController.text),
            child: Text(labels.submitFieldLabel),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              FlutterClipboard.copy(currentFen);
            },
            child: Text(labels.copyFenLabel),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              FlutterClipboard.paste().then((value) {
                if (chess.Chess.validate_fen(value)['valid'] == true) {
                  onPositionFenSubmitted(value);
                }
              });
            },
            child: Text(labels.pasteFenLabel),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              onPositionFenSubmitted(initialFen);
            },
            child: Text(labels.resetPosition),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              onPositionFenSubmitted(chess.Chess().fen);
            },
            child: Text(labels.standardPosition),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              onPositionFenSubmitted("8/8/8/8/8/8/8/8 w - - 0 1");
            },
            child: Text(labels.erasePosition),
          ),
        )
      ],
    );
  }
}
