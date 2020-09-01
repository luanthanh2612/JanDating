import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OccupationState with ChangeNotifier {
  List<DocumentSnapshot> occupation = [];

  OccupationState() {
    _load();
  }

  Future<void> _load() async {
    var _occupation = await Firestore.instance
        .collection('occupation')
        .orderBy('position')
        .getDocuments();
    occupation = _occupation.documents;
    notifyListeners();
  }
}
