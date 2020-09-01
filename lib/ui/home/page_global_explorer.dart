import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/shared-widgets/widget_user_card.dart';

class GlobalExplorer extends StatefulWidget {
  GlobalExplorer({this.center, this.currentUser});

  final GeoPoint center;
  final UserModel currentUser;

  @override
  _GlobalExplorerState createState() => _GlobalExplorerState();
}

class _GlobalExplorerState extends State<GlobalExplorer> {
  List<UserModel> users = [];
  bool isLoading = false;
  int atIndex = 0;

  @override
  void initState() {
    isLoading = true;
    fetchFirstList().then((snapshots) {
      atIndex = 0;
      users = snapshots;
      isLoading = false;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Text('Dang load');
    }

    if (users.length > 0 && atIndex < users.length) {
      return new UserCard(
        center: widget.center,
        user: users[atIndex],
        onSwipedLeft: () {
          if (atIndex > 0) {
            atIndex = atIndex - 1;
            setState(() {});
            print('tao giam atindex = $atIndex');
          }
        },
        onSwipedRight: () {
          if (users.length - 1 > atIndex) {
            atIndex = atIndex + 1;
            setState(() {});
            print('tao tang atindex = $atIndex');
          }
        },
        onRewind: () {},
        isShowRewind: true,
      );
    }

    return Text('trong rong');
  }

  Future<List<UserModel>> fetchFirstList() async {
    try {
      final documentList = (await FirebaseFirestore.instance
              .collection("users")
              .orderBy("uid")
              .limit(50)
              .get())
          .docs;
      print(documentList);

      return documentList
          .map((e) => UserModel.fromDocument(e.data(), e.id))
          .toList();
      //movieController.sink.add(documentList);
    } on SocketException {
      //movieController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      //movieController.sink.addError(e);
    }
  }
}

/* 

Future<List<DocumentSnapshot>> fetchFirstList() async {
    try {
      final documentList = (await FirebaseFirestore.instance
              .collection("users")
              .orderBy("uid")
              .limit(50)
              .get())
          .docs;
      print(documentList);
      return documentList;
      //movieController.sink.add(documentList);
    } on SocketException {
      //movieController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      //movieController.sink.addError(e);
    }
  }

Future<List<DocumentSnapshot>> fetchNextUsers() async {
  try {
    List<DocumentSnapshot> newDocumentList = (await FirebaseFirestore.instance
            .collection("users")
            .orderBy("rank")
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(50)
            .get())
        .docs;
    return newDocumentList;
  } on SocketException {
    //movieController.sink.addError(SocketException("No Internet Connection"));
  } catch (e) {
    print(e.toString());
    //movieController.sink.addError(e);
  }
}
*/
