import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';
import 'package:jan_app_flutter/shared-widgets/widget_user_card.dart';
import 'package:jan_app_flutter/ui/home/page_global_explorer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:swipe_stack/swipe_stack.dart';

List userRemoved = [];

class MainPageSearch extends StatefulWidget {
  @override
  _MainPageSearchState createState() => new _MainPageSearchState();
}

class _MainPageSearchState extends State<MainPageSearch> {
  int height = 180;
  int weight = 80;

  String education = 'Высшее';
  String occupation = "Работаю";
  String smoking = "Курю";
  String alcohol = "Употребляю";
  String sport = "Иногда";
  String maritalStatus = "Не был(а) в браке";
  String kids = "Детей нет";
  String zodiacSign = "Стрелец";

  bool _isLoading = false;
  ScrollController scrollController = ScrollController();
  bool isViewed = true;

  CollectionReference docRef = Firestore.instance.collection('users');

  GlobalKey<SwipeStackState> swipeKey = GlobalKey<SwipeStackState>();

  UserModel userRemoved;
  List<UserModel> usersAround = [];

  Geoflutterfire _geo;
  Geoflutterfire get geo => _geo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //var interestedUsers =
    //firestoreDatabase.getUsers(authProvider.currentUser.uid);
    GeoPoint center;
    int maxDistance = authProvider.currentUser.maxDistance;
    if (authProvider.currentUser.position != null) {
      center = authProvider.currentUser.position["geopoint"];
    } else {
      center = GeoPoint(37.421999899999996, -122.08405750000001);
    }

    return GlobalExplorer(
        center: center, currentUser: authProvider.currentUser);
    /*
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: StreamBuilder<List<UserModel>>(
        stream: firestoreDatabase.peopleAroundMeStream(
          center,
          maxDistance,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return Material(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Material(
              child: Center(child: Text('Oops! There\'s an error')),
            );
          }

          if (snapshot.data.isEmpty) {
            return Material(
              child: Center(child: Text('Oops! There\'s no one around you')),
            );
          }

          final users = snapshot.data;

          usersAround = users;
          usersAround.removeWhere(
              (element) => element.uid == authProvider.currentUser.uid);
          userRemoved = null;

          return FutureBuilder(
            future: Future.wait([
              firestoreDatabase.getCheckedList(authProvider.currentUser.uid),
              firestoreDatabase.getMatchedList(authProvider.currentUser.uid),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              List<String> listCheckedIds = snapshot.data[0];
              List<String> listMatchedIds = snapshot.data[1];
              var listMergedIds =
                  [...listCheckedIds, ...listMatchedIds].toSet().toList();
              users.removeWhere(
                  (element) => listMergedIds.contains(element.uid));

              return Stack(
                children: [
                  AbsorbPointer(
                    absorbing: false,
                    child: SwipeStack(
                      key: swipeKey,
                      children: usersAround.map((user) {
                        return SwiperItem(builder:
                            (SwiperPosition position, double progress) {
                          return UserCard(
                            user: user,
                            center: center,
                            onSwipedLeft: () {
                              swipeKey.currentState.swipeLeft();
                            },
                            onSwipedRight: () {
                              swipeKey.currentState.swipeRight();
                            },
                            onRewind: userRemoved != null
                                ? () {
                                    swipeKey.currentState.rewind();
                                  }
                                : null,
                            isShowRewind: true,
                          );
                        });
                      }).toList(growable: true),
                      threshold: 30,
                      maxAngle: 100,
                      visibleCount: 2,
                      historyCount: 1,
                      stackFrom: StackFrom.Right,
                      translationInterval: 1,
                      scaleInterval: 0.08,
                      padding: EdgeInsets.all(0.0),
                      onEnd: () => debugPrint("onEnd"),
                      onSwipe: (int index, SwiperPosition position) async {
                        print(position);
                        print(usersAround[index].firstName);
                        UserModel user = usersAround[index];

                        if (position == SwiperPosition.Left) {
                          // firestoreDatabase.passUser(
                          //     authProvider.currentUser.uid, user.uid);
                          userRemoved = user;
                          usersAround.removeAt(index);
                        } else if (position == SwiperPosition.Right) {
                          final flag = await firestoreDatabase.chooseUser(
                              authProvider.currentUser, user);

                          userRemoved = null;
                          usersAround.removeAt(index);

                          if (flag) {
                            showOverlayNotification((context) {
                              return MessageNotification(
                                title: 'Congratulation',
                                message: 'This is a match!',
                                url: user.photoUrl,
                                onReply: () {
                                  OverlaySupportEntry.of(context).dismiss();
                                  toast('you checked this message');
                                },
                              );
                            }, duration: Duration(milliseconds: 4000));
                          }
                        } else
                          debugPrint("onSwipe $index $position");
                      },
                      onRewind: (int index, SwiperPosition position) {
                        swipeKey.currentContext
                            .dependOnInheritedWidgetOfExactType();
                        usersAround.insert(index, userRemoved);
                        userRemoved = null;
                        // setState(() {
                        //   userRemoved = null;
                        // });
                        debugPrint("onRewind $index $position");
                        // print(usersAround[index].uid);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
    */
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
