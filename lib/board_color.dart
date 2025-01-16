import 'package:equatable/equatable.dart';

/// A side of the board (white/black).
class BoardColor extends Equatable {
  /// Value: 0 for white, 1 for black.
  final int value;

  /// Constructor
  const BoardColor._value(this.value);

  /// White side
  static const BoardColor white = BoardColor._value(0);

  /// Black side
  static const BoardColor black = BoardColor._value(1);

  /// String representation
  @override
  String toString() => (this == white) ? 'w' : 'b';

  @override
  List<Object?> get props => [value];
}
