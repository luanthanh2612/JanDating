import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:flutter_translate/localization_delegate.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jan_app_flutter/constants/icons.dart';
import 'package:jan_app_flutter/constants/styles.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PageSettings extends StatefulWidget {
  @override
  _PageSettingsState createState() => new _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  int _selectedLanguageIndex;
  LocalizationDelegate localizationDelegate;
  bool _messages;
  bool _sympathies;
  dynamic _userRef;

  @override
  Future<void> initState() {
    if (_messages == null || _sympathies) {
      _getSettings();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    localizationDelegate = LocalizedApp.of(context).delegate;
    if (_userRef == null) {
      _getUser();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('settings.title')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
//            await _userRef.setData(context.read<UserState>().profile);
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              translate('settings.notifications.label'),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.favorite, color: colorMain, size: 30),
                ),
                new Text(
                  translate('settings.notifications.sympathies'),
                  style: TextStyle(fontSize: 15),
                ),
                Spacer(),
                CupertinoSwitch(
                  activeColor: colorMain,
                  value: _sympathies,
                  onChanged: (bool value) async {
//                    context.read<UserState>().setNotificationSympathies(value);
                    setState(() {
                      _sympathies = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.message, color: colorMain, size: 30),
                ),
                new Text(
                  translate('settings.notifications.messages'),
                  style: TextStyle(fontSize: 15),
                ),
                Spacer(),
                CupertinoSwitch(
                  activeColor: colorMain,
                  value: _messages,
                  onChanged: (bool value) async {
//                    context.read<UserState>().setNotificationMessages(value);
                    setState(() {
                      _messages = value;
                    });
                    // await userRef.updateData(context.read<UserState>().profile);
                  },
                ),
              ],
            ),
            _drawLine(),
            Text(
              translate('settings.app-language.label'),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              child: Container(
                color: Colors.white.withOpacity(0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child:
                          Icon(JanIcons.language, color: colorMain, size: 30),
                    ),
                    Text(
                      translate(
                          'languages.${localizationDelegate.currentLocale.languageCode}'),
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Icon(JanIcons.arrow_right, size: 16),
                  ],
                ),
              ),
              onTap: () {
                _selectedLanguageIndex = localizationDelegate.supportedLocales
                    .map((e) => e.toString())
                    .toList()
                    .indexOf(localizationDelegate.currentLocale.languageCode);

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
                        height: 230,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: _languagePicker(),
                      );
                    });
              },
            ),
            _drawLine(),
            Text(
              translate('settings.tech-support.label'),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _sendMail('mailto:contact@jandating.com'),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 8,
                        child: Text(
                          translate('settings.tech-support.sub-label'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorGrey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Spacer(),
                      Icon(JanIcons.arrow_right, size: 16),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        translate('contact@jandating.com'),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawLine() {
    return Container(
      height: 0.5,
      color: colorGreyLight,
      margin: EdgeInsets.symmetric(vertical: 30),
    );
  }

  Widget _languagePicker() {
    _selectedLanguageIndex = localizationDelegate.supportedLocales
        .map((e) => e.toString())
        .toList()
        .indexOf(localizationDelegate.currentLocale.languageCode);
    return Column(children: [
      Row(
        children: [
          Spacer(),
          FlatButton(
            child: Text(translate('buttons.done'),
                style: TextStyle(
                    color: colorMain,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            onPressed: () {
              changeLocale(
                  context,
                  localizationDelegate.supportedLocales
                      .map((e) => e.toString())
                      .toList()[_selectedLanguageIndex]);
              Navigator.pop(context);
            },
          )
        ],
      ),
      Container(
        height: 150,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(
            initialItem: _selectedLanguageIndex,
          ),
          itemExtent: 45.0,
          onSelectedItemChanged: (int index) async {
            setState(() {
              _selectedLanguageIndex = index;
            });
          },
          children: new List<Widget>.generate(
            localizationDelegate.supportedLocales.length,
            (int index) {
              return new Center(
                child: new Text(
                    translate(
                      'languages.${localizationDelegate.supportedLocales[index]}',
                    ),
                    style: TextStyle(
                        color: (index == _selectedLanguageIndex)
                            ? colorMain
                            : Colors.black)),
              );
            },
          ),
        ),
      )
    ]);
  }

  Future<void> _sendMail(String url) async {
    try {
      await launch(url);
    } catch (e) {
      print(e);
      throw 'Could not launch $url';
    }
  }

  _getSettings() async {
    var notifications;
//    notifications = context.read<UserState>().notifications;
    if (notifications == null ||
        notifications['messages'] == null ||
        notifications['sympathies'] == null) {
      _messages = true;
      _sympathies = true;
    } else {
      _messages = notifications['messages'];
      _sympathies = notifications['sympathies'];
    }
  }

  _getUser() async {
    _userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
  }
}
