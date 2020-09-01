import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/models/filters.dart';
import 'package:jan_app_flutter/models/languages.dart';
import 'package:provider/provider.dart';

class PageFiltersLanguage extends StatefulWidget {
  @override
  _PageFiltersLanguageState createState() => new _PageFiltersLanguageState();
}

class _PageFiltersLanguageState extends State<PageFiltersLanguage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic languages;
  List<DocumentSnapshot> _languages = [];
  List<DocumentReference> _selectedLNGS = [];

  setLanguages() {
    final filterLanguage = context.read<FiltersState>().language;

    setState(() {
      _languages = languages.languages;
      DocumentSnapshot language;
      try {
        language = _languages
            .firstWhere((element) => element.data()['code'] == filterLanguage);
      } catch (e) {
        print('$e no element');
      }
      if (filterLanguage != null && language != null) {
        _selectedLNGS = [language.reference];
      }
    });
  }

  @override
  void initState() {
    languages = context.read<LanguagesState>();
    languages.addListener(setLanguages);

    setLanguages();
    super.initState();
  }

  @override
  void dispose() {
    languages.removeListener(setLanguages);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  translate('search-filter.languages-filter.title'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
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
                                          margin: EdgeInsets.only(right: 20.0),
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
                                                  .map((e) => e.path)
                                                  .toList()
                                                  .indexOf(_languages[index]
                                                      .reference
                                                      .path) !=
                                              -1,
                                          onChanged: (bool value) {
                                            if (value) {
                                              _selectedLNGS.clear();
                                              _saveFilter(data['code']);
                                              setState(() {
                                                _selectedLNGS = [
                                                  _languages[index].reference
                                                ];
                                              });
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
                  ],
                )),
          ),
        ],
      ),
    );
  }

  _saveFilter(language) {
    context.read<FiltersState>().setLanguage(language);
  }
}
