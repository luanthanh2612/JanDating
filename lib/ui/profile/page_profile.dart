import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';
import 'package:jan_app_flutter/shared-widgets/widget_profile_fields.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/constants/icons.dart';
import 'package:jan_app_flutter/shared-widgets/widget_profile_photo.dart';
import 'package:jan_app_flutter/shared-widgets/widget_profile_photo_requirements.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

final Geolocator _geolocator = Geolocator();

class PageProfile extends StatefulWidget {
  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  bool _isLoading = false;
  dynamic currentUser;
  dynamic languages;
  String _city = '...';
  String _country = '...';
  final TextEditingController _aboutController = TextEditingController();
  List<DocumentSnapshot> _languages = [];
  Future<String> _stringFuture;

  showLoader(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  @override
  void initState() {
    _getCurrentLocation();

    super.initState();
  }

  @override
  void dispose() {
    currentUser.removeListener(onSave);
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    if (authProvider.currentUser != null) {
      currentUser = authProvider.currentUser;
      _aboutController.text = currentUser != null ? currentUser.about : null;
      currentUser.addListener(onSave);
    }

    _textsProfileFuture = List.generate(_profileFields.length,
        (index) => _showFieldAnswer(authProvider, index));

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (_aboutController.text != authProvider.currentUser.about) {
            authProvider.currentUser.about = _aboutController.text;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(translate('my-profile.title')),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                WidgetProfilePhoto(
                  photos: currentUser.photos,
                  showLoader: showLoader,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 45, right: 45),
                  child: Text(
                    translate('add-photo-page.add-photo-description'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                WidgetProfilePhotoRequirements(),
                SizedBox(height: 45),
                _profileField(
                  JanIcons.location,
                  'my-profile.profile-data.labels.location',
                  Text(
                    '$_city, $_country',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorGrey,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _profileField(
                  JanIcons.birthday,
                  'my-profile.profile-data.labels.birthday',
                  Text(
                    '${DateFormat('dd.MM.yyyy').format(authProvider.currentUser.dateOfBirth)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorGrey,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.profile_languages);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        color: Colors.transparent,
                      ),
                      _profileField(
                        JanIcons.language,
                        'my-profile.profile-data.labels.known-languages',
                        Container(
                          width: 200,
                          height: 20,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _languages.length,
                            itemBuilder: (BuildContext context, int index) {
                              final data = languages[index];
                              return authProvider.currentUser.knownLanguages
                                          .toList()
                                          .indexOf(_languages[index]
                                              .data()['code']) !=
                                      -1
                                  ? Container(
                                      width: 25,
                                      margin: const EdgeInsets.only(right: 15),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5.0,
                                            color: Colors.black12,
                                          )
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/images/flags/${data['code']}.png',
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30,
                        top: 10,
                        child: Icon(
                          JanIcons.arrow_right,
                          size: 13,
                          color: colorGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: Text(
                    translate('my-profile.profile-about.title'),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 20,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      authProvider.currentUser.about = _aboutController.text;
                    },
                    decoration: InputDecoration(
                      hintText:
                          translate('my-profile.profile-about.placeholder'),
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    controller: _aboutController,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 600,
                  child: ListView.builder(
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => onEditProfileField(authProvider, index),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 65,
                              child: ListTile(
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 0, right: 10),
                                      child: Icon(_profileIcons[index],
                                          color: colorMain),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 2,
                                      child: Text(
                                        translate(
                                            'my-profile.profile-settings.${_profileFields[index]}'),
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FutureBuilder(
                                        future: _textsProfileFuture[index],
                                        initialData: '...',
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> text) {
                                          if (text.connectionState !=
                                              ConnectionState.done) {
                                            return Container();
                                          }
                                          if (text.hasError) {
                                            return Container();
                                          }
                                          return Text(
                                            text.data,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: colorGrey,
                                            ),
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: colorGreyLight,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 30,
                              child: Icon(
                                JanIcons.arrow_right,
                                size: 13,
                                color: colorGrey,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                FlatButton(
                  child: Text(
                    translate('my-profile.profile-actions.logout.label'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  textColor: colorMain,
                  disabledTextColor: Colors.grey,
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0),
                          ),
                        ),
                        isScrollControlled: true,
                        builder: (context) {
                          return Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(50, 20, 50, 10),
                                  child: RichText(
                                    text: new TextSpan(
                                      children: [
                                        TextSpan(
                                            text: translate(
                                                'my-profile.profile-actions.logout.message1'),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: translate(
                                                'my-profile.profile-actions.logout.message2'),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: translate(
                                                'my-profile.profile-actions.logout.message3'),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 40, 40, 10),
                                    child: Row(
                                      children: [
                                        FlatButton(
                                          child: Text(
                                              translate('buttons.cancel'),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorGreyLight)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Spacer(),
                                        FlatButton(
                                          child: Text(
                                              translate(
                                                  'my-profile.profile-actions.logout.okay'),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorMain)),
                                          onPressed: () async {
                                            await authProvider.signOut();
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.landing,
                                                (route) => false);
                                          },
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          );
                        });
                    /*await _auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/landing', (route) => false);*/
                  },
                ),
                _drawLine(),
                FlatButton(
                  child: Text(
                    translate(
                        'my-profile.profile-actions.delete-profile.label'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: colorGrey),
                  ),
                  textColor: colorMain,
                  disabledTextColor: Colors.grey,
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            topRight: const Radius.circular(30.0),
                          ),
                        ),
                        isScrollControlled: true,
                        builder: (context) {
                          return Container(
                            height: 220,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(55, 20, 55, 0),
                                  child: RichText(
                                    text: new TextSpan(
                                      children: [
                                        TextSpan(
                                            text: translate(
                                                'my-profile.profile-actions.delete-profile.message1'),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: translate(
                                                'my-profile.profile-actions.delete-profile.message2'),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: translate(
                                                'my-profile.profile-actions.delete-profile.message3'),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(50, 5, 50, 10),
                                  child: Text(
                                      translate(
                                          'my-profile.profile-actions.delete-profile.info'),
                                      style: TextStyle(
                                          fontSize: 12, color: colorGrey),
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 20, 40, 10),
                                    child: Row(
                                      children: [
                                        FlatButton(
                                          child: Text(
                                              translate('buttons.cancel'),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorGrey)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Spacer(),
                                        FlatButton(
                                          child: Text(
                                              translate(
                                                  'my-profile.profile-actions.delete-profile.okay'),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorMain)),
                                          onPressed: () {
                                            print('deleted');
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          );
                        });
                    /*await _auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/landing', (route) => false);*/
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest)
        .then((position) async {
      if (position != null) {
        final List<Placemark> place =
            await _geolocator.placemarkFromPosition(position);

        setState(() {
          _country = place.first.country;
          _city = place.first.locality;
//          showLocationErrorDialog = false;
        });
      }
    }).catchError((onError) {
//      setState(() {
//        showLocationErrorDialog = true;
//      });
    });
  }

  void onSave() async {
    print('onSave Profile');
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);
    await firestoreDatabase.setUser(currentUser);
  }

  Future<String> _showFieldAnswer(authProvider, index) async {
    final Map<String, dynamic> userProfile = authProvider.currentUser.toMap();
    if (userProfile[_profileDescriptions[index]] != null) {
      if (userProfile[_profileDescriptions[index]].runtimeType ==
          DocumentReference) {
        final value = await userProfile[_profileDescriptions[index]].get();
        final data = value.data();
        return translate('${data['label']}');
      } else {
        return '${userProfile[_profileDescriptions[index]]} ${translate(_profileLabels[index])}';
      }
    } else {
      return translate('my-profile.not-specified');
    }
  }

  List<Future<String>> _textsProfileFuture = [];
  List<dynamic> _profileIcons = [
    JanIcons.height,
    JanIcons.weight,
    JanIcons.education,
    JanIcons.occupation,
    Icons.smoking_rooms,
    JanIcons.alcohol,
    Icons.fitness_center,
    JanIcons.marital_status,
    JanIcons.kids,
    JanIcons.zodiac_sign
  ];
  List<String> _profileFields = [
    'height',
    'weight',
    'education',
    'occupation',
    'smoking',
    'alcohol',
    'sport',
    'maritalStatus',
    'kids',
    'zodiacSign'
  ];
  List<String> _profileLabels = ['my-profile.cm', 'my-profile.kg'];
  List<String> _profileDescriptions = [
    'height',
    'weight',
    'education',
    'occupation',
    'smoking',
    'alcohol',
    'sport',
    'marital-status',
    'kids',
    'zodiac-sign'
  ];

  void onEditProfileField(authProvider, index) {
    showModalBottomSheet(
        context: context,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(30.0),
            topRight: const Radius.circular(30.0),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      Icons.close,
                      color: colorMain,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        _profileIcons[index],
                        size: 45,
                        color: colorMain,
                      ),
                      SizedBox(height: 15),
                      Text(
                        translate(
                            'questionnaire-modal.titles.${_profileDescriptions[index]}'),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: WidgetProfileFields(
                            currentUser: authProvider.currentUser,
                            // appLocalizations: AppLocalizations.of(context),
                            index: index),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                FlatButton(
                  child: Text(
                    translate('enter-phone-number-page.continue-button'),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textColor: colorMain,
                  disabledTextColor: Colors.grey,
                  onPressed: () {
                    Navigator.pop(context);
                    if (index < 9) {
                      onEditProfileField(authProvider, index + 1);
                    }
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        }).whenComplete(() {
      _textsProfileFuture[index] = _showFieldAnswer(authProvider, index);
      setState(() {});
    });
  }

  Widget _profileField(icon, title, text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: colorMain),
        Container(
          width: MediaQuery.of(context).size.width - 100,
          margin: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                translate(title),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              text,
            ],
          ),
        ),
      ],
    );
  }

  Widget _drawLine() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: Container(
        height: 1,
        color: colorGreyLight,
      ),
    );
  }
}
