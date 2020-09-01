import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/models/language_model.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:jan_app_flutter/constants/styles.dart';

class PageSelectLanguages extends StatefulWidget {
  @override
  _PageSelectLanguagesState createState() => _PageSelectLanguagesState();
}

class _PageSelectLanguagesState extends State<PageSelectLanguages> {
  List<LanguageModel> _languages = [];
  List<LanguageModel> _selectedLNGS = [];

  @override
  void initState() {
//    setState(() {
//      _languages = context.read<LanguagesState>().languages;
//    });
//    context.read<LanguagesState>().addListener(() => setState(() {
//          _languages = context.read<LanguagesState>().languages;
//        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

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
              flex: 1,
              fit: FlexFit.tight,
              child: Align(
                alignment: FractionalOffset(0.5, 1),
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
                  child: StreamBuilder(
                    stream: firestoreDatabase.languagesStream(),
                    builder: (context, snapshot) {
                      _languages = snapshot.data;
                      if (snapshot.hasData && _languages.isNotEmpty) {
                        return Column(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: _languages.length > 0
                                  ? ListView.builder(
                                      itemCount: _languages.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.only(top: 20.0),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20.0),
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 5.0,
                                                        color: Colors.black12,
                                                      )
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    'assets/images/flags/${_languages[index].code}.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    translate(
                                                        'languages.${_languages[index].code}'),
                                                    style: TextStyle(
                                                        fontSize: 22.0),
                                                  ),
                                                ),
                                                CupertinoSwitch(
                                                  value: _selectedLNGS.indexOf(
                                                          _languages[index]) !=
                                                      -1,
                                                  onChanged: (bool value) {
                                                    if (_selectedLNGS.indexOf(
                                                            _languages[
                                                                index]) !=
                                                        -1) {
                                                      setState(() {
                                                        _selectedLNGS.removeAt(
                                                            _selectedLNGS
                                                                .indexOf(
                                                                    _languages[
                                                                        index]));
                                                      });
                                                    } else {
                                                      if (_selectedLNGS.length <
                                                          5) {
                                                        setState(() {
                                                          _selectedLNGS.add(
                                                              _languages[
                                                                  index]);
                                                        });
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
                              margin: EdgeInsets.only(top: 25),
                              child: Text(
                                translate(
                                    'select-languages-you-know-page.limit-message'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                )),
            Flexible(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        translate('enter-phone-number-page.continue-button'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ),
                      textColor: colorMain,
                      disabledTextColor: colorGrey,
                      onPressed: _selectedLNGS.length > 0
                          ? () => onSubmit(authProvider.currentUser)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit(UserModel user) async {
    user.knownLanguages = _selectedLNGS.map((e) => e.code).toList();
    Navigator.pushNamed(context, Routes.select_height);
  }
}
