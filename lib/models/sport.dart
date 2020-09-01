import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SportState with ChangeNotifier {
  List<DocumentSnapshot> sport = [];

  SportState() {
    _load();
  }

  Future<void> _load() async {
    var _sport = await Firestore.instance
        .collection('sport')
        .orderBy('position')
        .getDocuments();
    sport = _sport.documents;
    notifyListeners();
  }
}
