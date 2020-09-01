import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/models/languages.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:jan_app_flutter/constants/styles.dart';

class PageProfileLanguages extends StatefulWidget {
  // PageProfileLanguages({this.currentUser});

  // final UserModel currentUser;

  @override
  _PageProfileLanguagesState createState() => _PageProfileLanguagesState();
}

class _PageProfileLanguagesState extends State<PageProfileLanguages> {
  // _PageProfileLanguagesState(this.currentUser);

  UserModel _currentUser;

  dynamic languages;
  List<DocumentSnapshot> _languages = [];
  List<String> _selectedLNGS = [];

  setLanguages() {
    setState(() {
      _languages = languages.languages;
    });
  }

  @override
  void initState() {
    languages = context.read<LanguagesState>();
    languages.addListener(setLanguages);
    // setState(() {
    //   _languages = languages.languages;
    //   _selectedLNGS = currentUser.knownLanguages;
    // });
    _languages = languages.languages;
    //_selectedLNGS = currentUser.knownLanguages;
    super.initState();
  }

  @override
  void dispose() {
    languages.removeListener(setLanguages);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    _currentUser = authProvider.currentUser;
    _selectedLNGS = _currentUser.knownLanguages;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: Align(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    translate(
                        'select-languages-you-know-page.what-languages-do-you-know'),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 6,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: _languages.length > 0
                            ? ListView.builder(
                                itemCount: _languages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final data = _languages[index].data();
                                  return GestureDetector(
                                    child: Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 20.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin:
                                                EdgeInsets.only(right: 20.0),
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
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              translate(
                                                  'languages.${data['code']}'),
                                              style: TextStyle(fontSize: 22.0),
                                            ),
                                          ),
                                          CupertinoSwitch(
                                            value: _selectedLNGS
                                                    .map((e) => e)
                                                    .toList()
                                                    .indexOf(_languages[index]
                                                        .data()['code']) !=
                                                -1,
                                            onChanged: (bool value) {
                                              if (_selectedLNGS.length < 2 &&
                                                  value == false) {
                                                showErrorNotification(
                                                    context,
                                                    translate(
                                                        'select-languages-you-know-page.cant-remove-last-language'));
                                              } else {
                                                if (_selectedLNGS.indexOf(
                                                        _languages[index]
                                                            .reference
                                                            .path) !=
                                                    -1) {
                                                  setState(() {
                                                    _selectedLNGS.removeAt(
                                                        _selectedLNGS.indexOf(
                                                            _languages[index]
                                                                    .data()[
                                                                'code']));
                                                    onSubmit();
                                                  });
                                                } else {
                                                  if (_selectedLNGS.length <
                                                      5) {
                                                    setState(() {
                                                      _selectedLNGS.add(
                                                          _languages[index]
                                                              .data()['code']);
                                                      onSubmit();
                                                    });
                                                  }
                                                }
                                              }
                                            },
                                            activeColor: colorMain,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25, bottom: 25),
                        child: Text(
                          translate(
                              'select-languages-you-know-page.limit-message'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit() async {
    _currentUser.setKnownLanguages(_selectedLNGS);
  }
}
