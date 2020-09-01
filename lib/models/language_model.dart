import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

@immutable
class LanguageModel {
  const LanguageModel({
    @required this.id,
    @required this.code,
    @required this.label,
    @required this.index,
    @required this.reference,
  });
  final String id;
  final String code;
  final String label;
  final int index;
  final DocumentReference reference;

  factory LanguageModel.fromMap(Map<String, dynamic> data, String documentId,
      DocumentReference reference) {
    if (data == null) {
      return null;
    }
    final code = data['code'] as String;
    if (code == null) {
      return null;
    }
    final label = data['label'] as String;
    final index = data['index'] as int;
    return LanguageModel(
        id: documentId,
        code: code,
        label: label,
        index: index,
        reference: reference);
  }

  @override
  int get hashCode => hashValues(id, code, label, index);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final otherLanguage = other as LanguageModel;
    return id == otherLanguage.id &&
        code == otherLanguage.code &&
        label == otherLanguage.label &&
        index == otherLanguage.index;
  }

  @override
  String toString() => 'id: $id, code: $code, label: $label, index: $index';
}
