import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class KidsState with ChangeNotifier {
  List<DocumentSnapshot> kids = [];

  KidsState() {
    _load();
  }

  Future<void> _load() async {
    var _kids = await Firestore.instance
        .collection('kids')
        .orderBy('position')
        .getDocuments();
    kids = _kids.documents;
    notifyListeners();
  }
}
