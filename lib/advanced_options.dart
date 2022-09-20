import 'package:flutter/material.dart';
import 'package:super_string/super_string.dart';
import 'editable_chess_board.dart';
import 'utils.dart';

class AdvancedOptions extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final fenParts = currentFen.split(' ');
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
              currentFen: currentFen,
              labels: labels,
              onPositionFenSubmitted: onPositionFenSubmitted,
            ),
            const Divider(
              color: Colors.black,
            ),
            TurnWidget(
              labels: labels,
              currentFen: currentFen,
              onTurnChanged: onTurnChanged,
            ),
            const Divider(
              color: Colors.black,
            ),
            CastlesWidget(
              labels: labels,
              whiteOO: whiteOO,
              whiteOOO: whiteOOO,
              blackOO: blackOO,
              blackOOO: blackOOO,
              onWhiteOOChanged: onWhiteOOChanged,
              onWhiteOOOChanged: onWhiteOOOChanged,
              onBlackOOChanged: onBlackOOChanged,
              onBlackOOOChanged: onBlackOOOChanged,
            ),
            const Divider(
              color: Colors.black,
            ),
            EnPassantWidget(
              currentFen: currentFen,
              labels: labels,
              onChanged: onEnPassantChanged,
            ),
            const Divider(
              color: Colors.black,
            ),
            DrawHalfMovesCountWidget(
              currentFen: currentFen,
              labels: labels,
              onSubmitted: onHalfMoveCountSubmitted,
            ),
            const Divider(
              color: Colors.black,
            ),
            MoveNumberWidget(
              currentFen: currentFen,
              labels: labels,
              onSubmitted: onMoveNumberSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}

class TurnWidget extends StatefulWidget {
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
  State<TurnWidget> createState() => _TurnWidgetState();
}

class _TurnWidgetState extends State<TurnWidget> {
  bool _isWhiteTurn = true;

  @override
  void initState() {
    _isWhiteTurn = widget.currentFen.split(' ')[1] == 'w';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labels.playerTurnLabel,
        ),
        ListTile(
          title: Text(widget.labels.whitePlayerLabel),
          leading: Radio<bool>(
            groupValue: _isWhiteTurn,
            value: true,
            onChanged: (value) {
              setState(() {
                _isWhiteTurn = value ?? true;
                widget.onTurnChanged(_isWhiteTurn);
              });
            },
          ),
        ),
        ListTile(
          title: Text(widget.labels.blackPlayerLabel),
          leading: Radio<bool>(
            groupValue: _isWhiteTurn,
            value: false,
            onChanged: (value) {
              setState(() {
                _isWhiteTurn = value ?? false;
                widget.onTurnChanged(_isWhiteTurn);
              });
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

class EnPassantWidget extends StatefulWidget {
  final String currentFen;
  final Labels labels;
  final void Function(String?) onChanged;

  const EnPassantWidget({
    super.key,
    required this.currentFen,
    required this.labels,
    required this.onChanged,
  });

  @override
  State<EnPassantWidget> createState() => _EnPassantWidgetState();
}

class _EnPassantWidgetState extends State<EnPassantWidget> {
  late List<String> items;
  late String dropdownValue;

  @override
  void initState() {
    items = <String>[
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

    final fenParts = widget.currentFen.split(' ');
    final currentEpValue = fenParts[3];

    String epValue;

    if (currentEpValue == '-') {
      epValue = '-';
    } else if (currentEpValue.charAt(0) == 'a') {
      epValue = 'a';
    } else if (currentEpValue.charAt(0) == 'b') {
      epValue = 'b';
    } else if (currentEpValue.charAt(0) == 'c') {
      epValue = 'c';
    } else if (currentEpValue.charAt(0) == 'd') {
      epValue = 'd';
    } else if (currentEpValue.charAt(0) == 'e') {
      epValue = 'e';
    } else if (currentEpValue.charAt(0) == 'f') {
      epValue = 'f';
    } else if (currentEpValue.charAt(0) == 'g') {
      epValue = 'g';
    } else if (currentEpValue.charAt(0) == 'h') {
      epValue = 'h';
    } else {
      epValue = '-';
    }

    dropdownValue = epValue;
    super.initState();
  }

  bool _checkCorrectDropdown(String value) {
    final whiteTurn = widget.currentFen.split(' ')[1] == 'w';
    final rank = 7 - (whiteTurn ? 4 : 3);
    final expectedPawnValue = whiteTurn ? 'p' : 'P';
    final piecesArray = getPiecesArray(widget.currentFen);

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
    final whiteTurn = widget.currentFen.split(' ')[1] == 'w';

    if (!_checkCorrectDropdown(dropdownValue)) {
      setState(() {
        dropdownValue = items.first;
      });
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(widget.labels.enPassantLabel),
        DropdownButton<String>(
          value: dropdownValue,
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
                setState(() {
                  dropdownValue = value;
                  widget.onChanged(value);
                });
              }
            }
          },
        ),
        Text(dropdownValue != items.first ? (whiteTurn ? '6' : '3') : ''),
      ],
    );
  }
}

class DrawHalfMovesCountWidget extends StatefulWidget {
  final String currentFen;
  final Labels labels;
  final void Function(String) onSubmitted;

  const DrawHalfMovesCountWidget({
    super.key,
    required this.currentFen,
    required this.labels,
    required this.onSubmitted,
  });

  @override
  State<DrawHalfMovesCountWidget> createState() =>
      _DrawHalfMovesCountWidgetState();
}

class _DrawHalfMovesCountWidgetState extends State<DrawHalfMovesCountWidget> {
  final TextEditingController _fieldController =
      TextEditingController(text: '');

  @override
  void initState() {
    final String currentCount = widget.currentFen.split(' ')[4];
    _fieldController.text = currentCount;
    super.initState();
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
              widget.labels.drawHalfMovesCountLabel,
            ),
            Expanded(
              child: TextField(
                controller: _fieldController,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => widget.onSubmitted(_fieldController.text),
          child: Text(
            widget.labels.submitFieldLabel,
          ),
        )
      ],
    );
  }
}

class MoveNumberWidget extends StatefulWidget {
  final String currentFen;
  final Labels labels;
  final void Function(String) onSubmitted;

  const MoveNumberWidget({
    super.key,
    required this.currentFen,
    required this.labels,
    required this.onSubmitted,
  });

  @override
  State<MoveNumberWidget> createState() => _MoveNumberWidgetState();
}

class _MoveNumberWidgetState extends State<MoveNumberWidget> {
  final TextEditingController _fieldController =
      TextEditingController(text: '');

  @override
  void initState() {
    final String currentCount = widget.currentFen.split(' ')[5];
    _fieldController.text = currentCount;
    super.initState();
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
              widget.labels.moveNumberLabel,
            ),
            Expanded(
              child: TextField(
                controller: _fieldController,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => widget.onSubmitted(_fieldController.text),
          child: Text(
            widget.labels.submitFieldLabel,
          ),
        )
      ],
    );
  }
}

class FenControlsWidget extends StatefulWidget {
  final Labels labels;
  final String currentFen;
  final void Function(String) onPositionFenSubmitted;

  const FenControlsWidget({
    super.key,
    required this.labels,
    required this.currentFen,
    required this.onPositionFenSubmitted,
  });

  @override
  State<FenControlsWidget> createState() => _FenControlsWidgetState();
}

class _FenControlsWidgetState extends State<FenControlsWidget> {
  final TextEditingController _positionFenController =
      TextEditingController(text: '');

  @override
  void initState() {
    _positionFenController.text = widget.currentFen;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(widget.labels.currentPositionLabel),
            Expanded(
              child: TextField(
                controller: _positionFenController,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () =>
              widget.onPositionFenSubmitted(_positionFenController.text),
          child: Text(widget.labels.submitFieldLabel),
        ),
      ],
    );
  }
}
