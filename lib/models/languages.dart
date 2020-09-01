import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LanguagesState with ChangeNotifier {
  List<DocumentSnapshot> languages = [];

  LanguagesState() {
    _load();
  }

  Future<void> _load() async {
    var _languages = await Firestore.instance
        .collection('languages')
        .orderBy('index', descending: false)
        .getDocuments();
    languages = _languages.documents;
    notifyListeners();
  }
}
