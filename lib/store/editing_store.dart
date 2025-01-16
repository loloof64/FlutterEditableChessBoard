import 'package:editable_chess_board/piece.dart';
import 'package:mobx/mobx.dart';

part 'editing_store.g.dart';

// ignore: library_private_types_in_public_api
class EditingStore = _EditingStore with _$EditingStore;

const String initialFen =
    'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

abstract class _EditingStore with Store {
  @observable
  String fen = initialFen;

  @action
  void setFen(String value) => fen = value;

  @observable
  Piece? editingPiece;

  @action
  void setEditingPiece(Piece? value) => editingPiece = value;
}
