import 'package:flutter/material.dart';
import 'editable_chess_board.dart';
import 'utils.dart';

class AdvancedOptions extends StatelessWidget {
  final String currentFen;
  final Labels labels;
  final bool whiteOO;
  final bool whiteOOO;
  final bool blackOO;
  final bool blackOOO;

  final void Function(bool value) onTurnChanged;
  final void Function(bool?) onWhiteOOChanged;
  final void Function(bool?) onWhiteOOOChanged;
  final void Function(bool?) onBlackOOChanged;
  final void Function(bool?) onBlackOOOChanged;
  final void Function(String?) onEnPassantChanged;

  const AdvancedOptions({
    super.key,
    required this.currentFen,
    required this.labels,
    required this.whiteOO,
    required this.whiteOOO,
    required this.blackOO,
    required this.blackOOO,
    required this.onTurnChanged,
    required this.onWhiteOOChanged,
    required this.onWhiteOOOChanged,
    required this.onBlackOOChanged,
    required this.onBlackOOOChanged,
    required this.onEnPassantChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TurnWidget(
              labels: labels,
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
          ],
        ),
      ),
    );
  }
}

class TurnWidget extends StatefulWidget {
  final Labels labels;
  final void Function(bool turn) onTurnChanged;

  const TurnWidget({
    Key? key,
    required this.labels,
    required this.onTurnChanged,
  }) : super(key: key);

  @override
  State<TurnWidget> createState() => _TurnWidgetState();
}

class _TurnWidgetState extends State<TurnWidget> {
  bool _isWhiteTurn = true;

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
      widget.labels.fileALabel,
      widget.labels.fileBLabel,
      widget.labels.fileCLabel,
      widget.labels.fileDLabel,
      widget.labels.fileELabel,
      widget.labels.fileFLabel,
      widget.labels.fileGLabel,
      widget.labels.fileHLabel,
    ];
    dropdownValue = items.first;
    super.initState();
  }

  bool _checkCorrectDropdown(String value) {
    final whiteTurn = widget.currentFen.split(' ')[1] == 'w';
    final rank = whiteTurn ? 4 : 3;
    final expectedPawnValue = whiteTurn ? 'p' : 'P';
    final piecesArray = getPiecesArray(widget.currentFen);

    if (value == items.first) return true;
    if (value == widget.labels.fileALabel) {
      return piecesArray[rank][0] == expectedPawnValue;
    }
    if (value == widget.labels.fileBLabel) {
      return piecesArray[rank][1] == expectedPawnValue;
    }
    if (value == widget.labels.fileCLabel) {
      return piecesArray[rank][2] == expectedPawnValue;
    }
    if (value == widget.labels.fileDLabel) {
      return piecesArray[rank][3] == expectedPawnValue;
    }
    if (value == widget.labels.fileELabel) {
      return piecesArray[rank][4] == expectedPawnValue;
    }
    if (value == widget.labels.fileFLabel) {
      return piecesArray[rank][5] == expectedPawnValue;
    }
    if (value == widget.labels.fileGLabel) {
      return piecesArray[rank][6] == expectedPawnValue;
    }
    if (value == widget.labels.fileHLabel) {
      return piecesArray[rank][7] == expectedPawnValue;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ///////////////////////////
    print(widget.currentFen);
    ///////////////////////////

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
        Text(dropdownValue != items.first
            ? (whiteTurn ? widget.labels.rank6Label : widget.labels.rank3Label)
            : ''),
      ],
    );
  }
}
