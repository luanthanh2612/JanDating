import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jan_app_flutter/constants/icons.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/models/user_model.dart';

import 'image_slider/image_slider.dart';
import 'tagging/configurations.dart';
import 'tagging/taggable.dart';
import 'tagging/tagging.dart';

class UserCard extends StatelessWidget {
  UserCard({
    Key key,
    @required this.user,
    @required this.center,
    @required this.onSwipedLeft,
    @required this.onSwipedRight,
    @required this.onRewind,
    this.isShowRewind,
  }) : super(key: key);

  final UserModel user;
  final GeoPoint center;
  final Function onSwipedLeft;
  final Function onSwipedRight;
  final Function onRewind;
  final bool isShowRewind;

  final List<String> _profileLabels = ['my-profile.cm', 'my-profile.kg'];

  @override
  Widget build(BuildContext context) {
    final GeoPoint userPoint = user.position["geopoint"];

    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Align(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.3,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Stack(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection("photos")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Material(
                                child: Container(),
                              );
                            }

                            if (snapshot.data.docs.length == 0) {
                              return Material(
                                child: Container(),
                              );
                            }

                            final List<String> _imageUrls = [];
                            snapshot.data.docs.forEach((element) {
                              final data = element.data();
                              _imageUrls.add(data["url"] as String);
                            });

                            // return Swiper(
                            //   itemBuilder: (BuildContext context, int index) {
                            //     return new Image.asset(
                            //       _imageUrls[index],
                            //       fit: BoxFit.fill,
                            //     );
                            //   },

                            //   //indicatorLayout: PageIndicatorLayout.COLOR,
                            //   autoplay: true,
                            //   itemCount: _imageUrls.length,
                            //   pagination: new SwiperPagination(),
                            //   control: new SwiperControl(),
                            // );
                            return ImageSliderWidget(
                              imageUrls: _imageUrls,
                              imageBorderRadius: BorderRadius.circular(8.0),
                              imageHeight: MediaQuery.of(context).size.height,
                            );
                          },
                        ),
                        userPoint != null
                            ? Positioned(
                                left: 15,
                                bottom: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder<List<Placemark>>(
                                      future: Geolocator()
                                          .placemarkFromCoordinates(
                                              userPoint.latitude,
                                              userPoint.longitude),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }

                                        final Placemark pm =
                                            snapshot.data.first;
                                        return Row(
                                          children: [
                                            Text(
                                                user.firstName != null
                                                    ? user.firstName
                                                    : '',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            Text(', ${pm.country}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15)),
                                          ],
                                        );
                                      },
                                    ),
                                    FutureBuilder(
                                        future: Geolocator().distanceBetween(
                                            center.latitude,
                                            center.longitude,
                                            userPoint.latitude,
                                            userPoint.longitude),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container();
                                          }

                                          return Text(
                                            '~ ${snapshot.data.toInt()} км',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                            textAlign: TextAlign.right,
                                          );
                                        })
                                  ],
                                ))
                            : Container(),
                      ],
                    )),
              ),
              alignment: Alignment.center,
            ),
          ),
          (user.about != null && user.about != '')
              ? Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          style: BorderStyle.solid, color: colorGreyLight),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: colorGreyLight,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(user.about != null ? user.about : '',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.left),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: FlutterTagging<TagItem>(
              initialItems: _generateTags(context, user),
              configureChip: (tagItem) {
                return ChipConfiguration(
                  avatar: tagItem.icon,
                  label: tagItem.content,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: colorGreyLight, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelStyle: TextStyle(color: Colors.white),
                  padding: EdgeInsets.all(0.0),
                  labelPadding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                  shadowColor: colorGreyLight,
                  elevation: 0.5,
                );
              },
              wrapConfiguration: WrapConfiguration(
                runSpacing: 0.0,
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 45, top: 20, right: 45, bottom: 40.0),
            child: Container(
              height: 100,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          height: 65,
                          width: 65,
                          child: FlatButton(
                            color: colorGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0)),
                            child: Icon(JanIcons.close,
                                color: Colors.white, size: 30),
                            padding: EdgeInsets.all(5),
                            onPressed: () {
                              onSwipedLeft();
                            },
                          )),
                      Spacer(),
                      Container(
                          height: 65,
                          width: 65,
                          // alignment: Alignment.center,
                          child: FlatButton(
                            color: colorMain,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0)),
                            child: Icon(JanIcons.sympathy,
                                color: Colors.white, size: 30),
                            padding: EdgeInsets.fromLTRB(0, 4, 4, 4),
                            onPressed: () {
                              onSwipedRight();
                            },
                          )),
                    ],
                  ),
                  isShowRewind
                      ? Positioned(
                          bottom: 10.0,
                          child: IconButton(
                            color: colorGrey,
                            icon: Icon(Icons.redo, color: Color(0xFFCEBB0E)),
                            iconSize: 100.0,
                            padding: EdgeInsets.all(5),
                            onPressed: () {
                              onRewind();
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _generateTags(BuildContext context, UserModel user) {
    List<TagItem> listTemp = [];

    if (user.knownLanguages != null) {
      List<Widget> languages = [];
      user.knownLanguages.forEach((language) {
        languages.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: Image.asset(
            'assets/images/flags/$language.png',
            fit: BoxFit.cover,
            height: 15.0,
            width: 32.0,
          ),
        ));
      });

      TagItem tag = TagItem(
        icon: Icon(JanIcons.language, color: colorMain, size: 18),
        content: Container(
          width: languages.length * 42.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: languages,
          ),
        ),
      );
      listTemp.add(tag);
    }

    if (user.height != null) {
      TagItem tag = TagItem(
        icon: Icon(JanIcons.height, color: colorMain, size: 18),
        content: Text('${user.height} ${translate(_profileLabels.first)}',
            style: TextStyle(fontSize: 13, color: Colors.black)),
      );
      listTemp.add(tag);
    }

    if (user.weight != null) {
      TagItem tag = TagItem(
        icon: Icon(JanIcons.weight, color: colorMain, size: 18),
        content: Text('${user.weight} ${translate(_profileLabels.last)}',
            style: TextStyle(fontSize: 13, color: Colors.black)),
      );
      listTemp.add(tag);
    }

    if (user.education != null) {
      TagItem eduTag = TagItem(
        icon: Icon(JanIcons.education, color: colorMain, size: 18),
        content: FutureBuilder<DocumentSnapshot>(
          future: user.education.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data.data();
            final String education = data["label"];
            return Text(translate(education),
                style: TextStyle(fontSize: 13, color: Colors.black));
          },
        ),
      );
      listTemp.add(eduTag);
    }

    if (user.occupation != null) {
      TagItem occupationTag = TagItem(
        icon: Icon(JanIcons.occupation, color: colorMain, size: 18),
        content: FutureBuilder<DocumentSnapshot>(
          future: user.education.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data.data();
            final String occupation = data["label"];
            return Text(translate(occupation),
                style: TextStyle(fontSize: 13, color: Colors.black));
          },
        ),
      );
      listTemp.add(occupationTag);
    }

    if (user.smoking != null) {
      TagItem smokingTag = TagItem(
        icon: Icon(Icons.smoking_rooms, color: colorMain, size: 18),
        content: FutureBuilder<DocumentSnapshot>(
          future: user.education.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data.data();
            final String smoking = data["label"];
            return Text(translate(smoking),
                style: TextStyle(fontSize: 13, color: Colors.black));
          },
        ),
      );
      listTemp.add(smokingTag);
    }

    if (user.alcohol != null) {
      TagItem alcoholTag = TagItem(
        icon: Icon(JanIcons.alcohol, color: colorMain, size: 18),
        content: FutureBuilder<DocumentSnapshot>(
          future: user.education.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data.data();
            final String alcohol = data["label"];
            return Text(translate(alcohol),
                style: TextStyle(fontSize: 13, color: Colors.black));
          },
        ),
      );
      listTemp.add(alcoholTag);
    }

    if (user.sport != null) {
      TagItem sportTag = TagItem(
        icon: Icon(Icons.fitness_center, color: colorMain, size: 18),
        content: FutureBuilder<DocumentSnapshot>(
          future: user.education.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data.data();
            final String sport = data["label"];
            return Text(translate(sport),
                style: TextStyle(fontSize: 13, color: Colors.black));
          },
        ),
      );
      listTemp.add(sportTag);
    }

    if (user.maritalStatus != null) {
      TagItem maritalTag = TagItem(
        icon: Icon(JanIcons.marital_status, color: colorMain, size: 18),
        content: FutureBuilder<DocumentSnapshot>(
          future: user.education.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data.data();
            final String maritalStatus = data["label"];
            return Text(translate(maritalStatus),
                style: TextStyle(fontSize: 13, color: Colors.black));
          },
        ),
      );
      listTemp.add(maritalTag);
    }

    if (user.kids != null) {
      TagItem kidsTag = TagItem(
        icon: Icon(JanIcons.kids, color: colorMain, size: 18),
        content: FutureBuilder<DocumentSnapshot>(
          future: user.education.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data.data();
            final String kids = data["label"];
            return Text(translate(kids),
                style: TextStyle(fontSize: 13, color: Colors.black));
          },
        ),
      );
      listTemp.add(kidsTag);
    }

    if (user.zodiacSign != null) {
      TagItem zodiacTag = TagItem(
        icon: Icon(JanIcons.zodiac_sign, color: colorMain, size: 18),
        content: FutureBuilder<DocumentSnapshot>(
          future: user.education.get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final data = snapshot.data.data();
            final String zodiacSign = data["label"];
            return Text(translate(zodiacSign),
                style: TextStyle(fontSize: 13, color: Colors.black));
          },
        ),
      );
      listTemp.add(zodiacTag);
    }

    return listTemp;
  }
}

class TagItem extends Taggable {
  ///
  final Icon icon;

  ///
  final Widget content;

  ///
  final int position;

  /// Creates Language
  TagItem({
    this.icon,
    this.content,
    this.position,
  });

  @override
  List<Object> get props => [content];

  /// Converts the class to json string.
  String toJson() => '''  {
    "name": $content,\n
    "position": $position\n
  }''';
}

class MessageNotification extends StatelessWidget {
  final VoidCallback onReply;
  final String message;
  final String title;
  final String url;

  const MessageNotification({
    Key key,
    @required this.onReply,
    @required this.message,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorMain, width: 1.0)),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: url,
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text(message),
          trailing: IconButton(
              icon: Icon(
                JanIcons.arrow_right,
                size: 13,
                color: colorGrey,
              ),
              onPressed: () {
                if (onReply != null) onReply();
              }),
        ),
      ),
    );
  }
}
