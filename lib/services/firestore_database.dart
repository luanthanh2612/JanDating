import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jan_app_flutter/models/language_model.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:jan_app_flutter/services/firestore_path.dart';
import 'package:jan_app_flutter/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

/*
This is the main class access/call for any UI widgets that require to perform
any CRUD activities operation in Firestore database.
This class work hand-in-hand with FirestoreService and FirestorePath.

Notes:
For cases where you need to have a special method such as bulk update specifically
on a field, then is ok to use custom code and write it here. For example,
setAllTodoComplete is require to change all todos item to have the complete status
changed to true.

 */
class FirestoreDatabase {
  // FirestoreDatabase({@required this.uid})
  //   : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');

  FirestoreDatabase();

  //final String uid;
  final _firestoreService = FirestoreService.instance;

  //Method to retrieve all languages item from the same user based on uid
  Stream<List<LanguageModel>> languagesStream() =>
      _firestoreService.collectionStream(
        path: FirestorePath.languages(),
        builder: (data, documentId, reference) =>
            LanguageModel.fromMap(data, documentId, reference),
        queryBuilder: (query) {
          return query.orderBy('index', descending: false);
        },
      );

  //Method related to photos
  //Method to retrieve all profile photos
  Stream<List<PhotoModel>> profilePhotosStream(String uid) =>
      _firestoreService.collectionStream(
        path: FirestorePath.photos(uid),
        builder: (data, documentId, reference) => PhotoModel.fromData(data),
      );

  Future<List<PhotoModel>> profilePhotosFuture(String uid) =>
      _firestoreService.documentsFuture(
        path: FirestorePath.photos(uid),
        builder: (data, documentId, reference) => PhotoModel.fromData(data),
      );

  //Method to create/update photo
  // Future<void> setPhoto(PhotoModel photo, String uid) async =>
  //     await _firestoreService.setData(
  //       path: FirestorePath.photo(uid, photo.),
  //       data: photo.toMap(),
  //     );

  Future<void> deleteAllPhotos(String uid) async {
    final batchDelete = FirebaseFirestore.instance.batch();

    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirestorePath.photos(uid))
        .get();

    for (DocumentSnapshot ds in querySnapshot.docs) {
      batchDelete.delete(ds.reference);
    }
    await batchDelete.commit();
  }

  //Method for user
  //Method to retrieve userModel object based on the given uid
  Stream<UserModel> userStream({@required String userId}) =>
      _firestoreService.documentStream(
        path: FirestorePath.user(userId),
        builder: (data, documentID) => UserModel.fromDocument(data, documentID),
      );

  Future<UserModel> userFuture({@required String userId}) {
    return _firestoreService.documentFuture(
      path: FirestorePath.user(userId),
      builder: (data, documentID) =>
          data != null ? UserModel.fromDocument(data, documentID) : null,
    );
  }

  //Create/update userModel
  Future<void> setUser(UserModel user) async => await _firestoreService.setData(
        path: FirestorePath.user(user.uid),
        data: user.toMap(),
      );

  Future<void> setUserWithField(
          UserModel user, String field, dynamic value) async =>
      await _firestoreService.setData(
        path: FirestorePath.user(user.uid),
        data: user.toMapWithField(field, value),
      );

  Stream<List<UserModel>> peopleAroundMeStream(GeoPoint geoPoint, int radius) =>
      _firestoreService.collectionStream1(
        geoPoint: geoPoint,
        radius: radius,
        path: FirestorePath.users(),
        builder: (data, documentId, reference) =>
            UserModel.fromDocument(data, documentId),
        queryBuilder: (query) {
          return query.orderBy('dateOfBirth', descending: false);
        },
      );

  Future<List<UserModel>> peopleAroundMeFuture(GeoPoint geoPoint, int radius) =>
      _firestoreService.documentsFuture1(
        geoPoint: geoPoint,
        radius: radius,
        path: FirestorePath.users(),
        builder: (data, documentId, reference) =>
            UserModel.fromDocument(data, documentId),
        queryBuilder: (query) {
          return query.orderBy('dateOfBirth', descending: false);
        },
      );

  Future<List<UserModel>> peopleAroundMeFuture1() =>
      _firestoreService.documentsFuture(
        path: FirestorePath.users(),
        builder: (data, documentId, reference) =>
            UserModel.fromDocument(data, documentId),
        queryBuilder: (query) {
          return query.orderBy('dateOfBirth', descending: false);
        },
      );

  Stream<List<String>> likedByPeopleStream(String uid) =>
      _firestoreService.collectionStream(
        path: FirestorePath.likedBy(uid),
        builder: (data, documentId, reference) => documentId,
      );

  /// User Repository
  /// Will migrate to another file
  Future<bool> chooseUser(UserModel currentUser, UserModel selectedUser) async {
    final users = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('selectedList')
        .get();

    List temp = users.docs.map((e) => e.id).toList();
    if (temp.contains(selectedUser.uid)) {
      this.selectUser(currentUser, selectedUser);
      return true;
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('checkedList')
          .doc(selectedUser.uid)
          .set({});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(selectedUser.uid)
          .collection('selectedList')
          .doc(currentUser.uid)
          .set({
        'firstName': selectedUser.firstName,
      });
      return false;
    }

//    await FirebaseFirestore.instance
//        .collection('users')
//        .doc(selectedUser.uid)
//        .collection('checkedList')
//        .doc(currentUserId)
//        .set({});
  }

  Future<List<UserModel>> getUsers(userId) async {
    UserModel _user = UserModel();
    List<String> checkedList = await getCheckedList(userId);
    UserModel currentUser = await getUserInterests(userId);

    await FirebaseFirestore.instance.collection('users').get().then((users) {
      for (var user in users.docs) {
        if ((!checkedList.contains(user.id)) &&
                (user.id !=
                    userId) /*&&
            (currentUser.interestedIn == user['gender']) &&
            (user['interestedIn'] == currentUser.gender)*/
            ) {
          _user = UserModel.fromDocument(user.data(), user.id);
          break;
        }
      }
    });

    return [_user];
  }

  Future<UserModel> getUser(userId) async {
    UserModel _user = UserModel();
    List<String> checkedList = await getCheckedList(userId);
    UserModel currentUser = await getUserInterests(userId);

    await FirebaseFirestore.instance.collection('users').get().then((users) {
      for (var user in users.docs) {
        if ((!checkedList.contains(user.id)) &&
                (user.id !=
                    userId) /*&&
            (currentUser.interestedIn == user['gender']) &&
            (user['interestedIn'] == currentUser.gender)*/
            ) {
          _user = UserModel.fromDocument(user.data(), user.id);
          break;
        }
      }
    });

    return _user;
  }

  passUser(currentUserId, selectedUserId) async {
//    await FirebaseFirestore.instance
//        .collection('users')
//        .doc(selectedUserId)
//        .collection('selectedList')
//        .doc(currentUserId)
//        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('checkedList')
        .doc(selectedUserId)
        .set({});
    return getUser(currentUserId);
  }

  Future getUserInterests(userId) async {
    UserModel currentUser;

    final temp =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    currentUser = UserModel.fromDocument(temp.data(), temp.documentID);
    return currentUser;
  }

  Future<List<String>> getCheckedList(userId) async {
    List<String> checkedList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('checkedList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        if (docs.docs != null) {
          checkedList.add(doc.id);
        }
      }
    });
    return checkedList;
  }

  /// Match Repository
  /// Will migrate to another file
  Future<List<String>> getMatchedList(userId) async {
    List<String> matchedList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('matchedList')
        .get()
        .then((docs) {
      matchedList = docs.docs.map((e) => e.id).toList();
    });
    return matchedList;
  }

  Stream<List<Map<String, dynamic>>> getMatchedListStream(userId) {
    final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('matchedList')
        .orderBy(
          'timestamp',
          descending: false,
        )
        .snapshots();

    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((doc) => doc.data())
          .where((value) => value != null)
          .toList();
      return result;
    });
  }

  Stream<QuerySnapshot> getSelectedList(userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('selectedList')
        .snapshots();
  }

  void deleteUser(currentUserId, selectedUserId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('selectedList')
        .doc(selectedUserId)
        .delete();
  }

  Future selectUser(UserModel currentUser, UserModel selectedUser) async {
    deleteUser(currentUser.uid, selectedUser.uid);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('matchedList')
        .doc(selectedUser.uid)
        .set({
      'uid': selectedUser.uid,
      'firstName': selectedUser.firstName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(selectedUser.uid)
        .collection('matchedList')
        .doc(currentUser.uid)
        .set({
      'uid': currentUser.uid,
      'firstName': currentUser.firstName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

//Method to mark all todoModel to be complete
//  Future<void> setAllTodoComplete() async {
//    final batchUpdate = FirebaseFirestore.instance.batch();
//
//    final querySnapshot = await FirebaseFirestore.instance
//        .collection(FirestorePath.todos(uid))
//        .get();
//
//    for (DocumentSnapshot ds in querySnapshot.documents) {
//      batchUpdate.updateData(ds.reference, {'complete': true});
//    }
//    await batchUpdate.commit();
//  }
//
//  Future<void> deleteAllTodoWithComplete() async {
//    final batchDelete = FirebaseFirestore.instance.batch();
//
//    final querySnapshot = await FirebaseFirestore.instance
//        .collection(FirestorePath.todos(uid))
//        .where('complete', isEqualTo: true)
//        .get();
//
//    for (DocumentSnapshot ds in querySnapshot.documents) {
//      batchDelete.delete(ds.reference);
//    }
//    await batchDelete.commit();
//  }
