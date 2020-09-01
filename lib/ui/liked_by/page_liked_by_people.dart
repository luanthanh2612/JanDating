import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';
import 'package:jan_app_flutter/shared-widgets/widget_user_card.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';

class LikedByPeople extends StatefulWidget {
  LikedByPeople({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LikedByPeopleState createState() => _LikedByPeopleState();
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

class _LikedByPeopleState extends State<LikedByPeople> {
  @override
  Widget build(BuildContext context) {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      primary: false,
      appBar: EmptyAppBar(),
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
            child: Text(
              'Upgrade to Gold to see people who already liked you.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorMain,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          getGridView(authProvider, firestoreDatabase),
        ],
      ),
    );
  }

  Widget getGridView(authProvider, firestoreDatabase) {
    return StreamBuilder<List<String>>(
      stream:
          firestoreDatabase.likedByPeopleStream(authProvider.currentUser.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data.length == 0) {
          return Container();
        }

        final users = snapshot.data;

        return GridView.builder(
          shrinkWrap: true,
          primary: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio:
                (MediaQuery.of(context).size.width - 60 / 2) / 460,
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            GeoPoint center = authProvider.currentUser.position["geopoint"];
            return createTile(
              users[index],
              center,
              index,
              _selectedIndex,
              index % 2 == 0 ? false : true,
              '',
              Colors.purple,
              null,
              firestoreDatabase,
              authProvider.currentUser,
            );
          },
        );
      },
    );
  }

  int _selectedIndex = -1;
  Widget createTile(
      String uid,
      GeoPoint center,
      int index,
      int selectedIndex,
      bool isEven,
      String title,
      Color color,
      IconData icon,
      FirestoreDatabase firestoreDatabase,
      UserModel currentUser) {
    return Padding(
      padding: EdgeInsets.only(
          left: isEven ? 10 : 20, right: isEven ? 20 : 10, top: 10, bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<UserModel>(
          future: firestoreDatabase.userFuture(userId: uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            final user = snapshot.data;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                showGeneralDialog(
                  context: context,
                  barrierColor:
                      Colors.black12.withOpacity(0.6), // background color
                  barrierDismissible:
                      false, // should dialog be dismissed when tapped outside
                  barrierLabel: "Dialog", // label for barrier
                  transitionDuration: Duration(
                      milliseconds:
                          400), // how long it takes to popup dialog after button click
                  pageBuilder: (_, __, ___) {
                    // your widget implementation
                    return SizedBox.expand(
                      // makes widget fullscreen
                      child: Material(
                        child: Stack(
                          children: <Widget>[
                            UserCard(
                              user: user,
                              center: center,
                              onSwipedLeft: () => Navigator.pop(context),
                              onSwipedRight: () async {
                                final flag = await firestoreDatabase.chooseUser(
                                  currentUser,
                                  user,
                                );

                                Navigator.pop(context);

                                if (flag) {
                                  showOverlayNotification((context) {
                                    return MessageNotification(
                                      title: 'Congratulation',
                                      message: 'This is a match!',
                                      url: user.photoUrl,
                                      onReply: () {
                                        OverlaySupportEntry.of(context)
                                            .dismiss();
                                        toast('you checked this message');
                                      },
                                    );
                                  }, duration: Duration(milliseconds: 4000));
                                }
                              },
                              onRewind: () {},
                              isShowRewind: false,
                            ),
                            Positioned(
                              top: 40,
                              left: 5,
                              child: FlatButton(
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 40.0,
                                  color: colorMain,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          user.photoUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(width: 1.0, color: colorMain),
                    ),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: BlurryEffect(0.95, 15.0,
                        Colors.white.withOpacity(0.0)), //Colors.grey.shade200),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class BlurryEffect extends StatelessWidget {
  final double opacity;
  final double blurry;
  final Color shade;

  BlurryEffect(this.opacity, this.blurry, this.shade);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: shade.withOpacity(opacity),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(width: 1.0, color: colorMain),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurry, sigmaY: blurry),
          child: Container(
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

/*child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/girl.jpg',
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              child: Container(
                width: double.infinity,
                color: Colors.black12,
              ),
              filter: ui.ImageFilter.blur(sigmaY: 10, sigmaX: 10),
            )
          ],
        ),
      ),*/
