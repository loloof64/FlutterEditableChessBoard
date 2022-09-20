import 'package:flutter/material.dart';

class Labels {
  final String playerTurnLabel;
  final String whitePlayerLabel;
  final String blackPlayerLabel;
  final String availableCastlesLabel;
  final String whiteOOLabel;
  final String whiteOOOLabel;
  final String blackOOLabel;
  final String blackOOOLabel;

  Labels({
    required this.playerTurnLabel,
    required this.whitePlayerLabel,
    required this.blackPlayerLabel,
    required this.availableCastlesLabel,
    required this.whiteOOLabel,
    required this.whiteOOOLabel,
    required this.blackOOLabel,
    required this.blackOOOLabel,
  });
}

class AdvancedOptions extends StatelessWidget {
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

  const AdvancedOptions({
    super.key,
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
            )
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
