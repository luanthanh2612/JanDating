import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SmokingState with ChangeNotifier {
  List<DocumentSnapshot> smoking = [];

  SmokingState() {
    _load();
  }

  Future<void> _load() async {
    var _smoking = await Firestore.instance
        .collection('smoking')
        .orderBy('position')
        .getDocuments();
    smoking = _smoking.documents;
    notifyListeners();
  }
}
