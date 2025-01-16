// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editing_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditingStore on _EditingStore, Store {
  late final _$fenAtom = Atom(name: '_EditingStore.fen', context: context);

  @override
  String get fen {
    _$fenAtom.reportRead();
    return super.fen;
  }

  @override
  set fen(String value) {
    _$fenAtom.reportWrite(value, super.fen, () {
      super.fen = value;
    });
  }

  late final _$editingPieceAtom =
      Atom(name: '_EditingStore.editingPiece', context: context);

  @override
  Piece? get editingPiece {
    _$editingPieceAtom.reportRead();
    return super.editingPiece;
  }

  @override
  set editingPiece(Piece? value) {
    _$editingPieceAtom.reportWrite(value, super.editingPiece, () {
      super.editingPiece = value;
    });
  }

  late final _$_EditingStoreActionController =
      ActionController(name: '_EditingStore', context: context);

  @override
  void setFen(String value) {
    final _$actionInfo = _$_EditingStoreActionController.startAction(
        name: '_EditingStore.setFen');
    try {
      return super.setFen(value);
    } finally {
      _$_EditingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEditingPiece(Piece? value) {
    final _$actionInfo = _$_EditingStoreActionController.startAction(
        name: '_EditingStore.setEditingPiece');
    try {
      return super.setEditingPiece(value);
    } finally {
      _$_EditingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fen: ${fen},
editingPiece: ${editingPiece}
    ''';
  }
}
