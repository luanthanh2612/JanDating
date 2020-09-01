import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AlcoholState with ChangeNotifier {
  List<DocumentSnapshot> alcohol = [];

  AlcoholState() {
    _load();
  }

  Future<void> _load() async {
    var _alcohol = await Firestore.instance
        .collection('alcohol')
        .orderBy('position')
        .getDocuments();
    alcohol = _alcohol.documents;
    notifyListeners();
  }
}
