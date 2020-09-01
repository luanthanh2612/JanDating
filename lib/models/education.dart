import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EducationState with ChangeNotifier {
  List<DocumentSnapshot> education = [];

  EducationState() {
    _load();
  }

  Future<void> _load() async {
    var _education = await Firestore.instance
        .collection('education')
        .orderBy('position')
        .getDocuments();
    education = _education.documents;
    notifyListeners();
  }
}
