import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ZodiacSignsState with ChangeNotifier {
  List<DocumentSnapshot> zodiac = [];

  ZodiacSignsState() {
    _load();
  }

  Future<void> _load() async {
    var _zodiac = await Firestore.instance
        .collection('zodiac-signs')
        .orderBy('position')
        .getDocuments();
    zodiac = _zodiac.documents;
    notifyListeners();
  }
}
