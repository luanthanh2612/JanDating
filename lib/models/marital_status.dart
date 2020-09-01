import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MaritalStatusState with ChangeNotifier {
  List<DocumentSnapshot> maritalStatus = [];

  MaritalStatusState() {
    _load();
  }

  Future<void> _load() async {
    var _maritalStatus = await Firestore.instance
        .collection('marital-status')
        .orderBy('position')
        .getDocuments();

    maritalStatus = _maritalStatus.documents;
    notifyListeners();
  }
}
