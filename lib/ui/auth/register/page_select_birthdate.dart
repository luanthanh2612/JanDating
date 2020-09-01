import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jan_app_flutter/constants/styles.dart';

class PageSelectBirthDate extends StatefulWidget {
  @override
  _PageSelectBirthDateState createState() => _PageSelectBirthDateState();
}

class _PageSelectBirthDateState extends State<PageSelectBirthDate> {
  DateTime _birthDate;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                    translate('enter-birthday-page.enter-birthday'),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: colorMain,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      padding: EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 200,
                                  child: Column(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 1,
                                        child: Align(
                                          alignment: FractionalOffset(1, 1),
                                          child: FlatButton(
                                            child: Text(
                                              translate(
                                                  'search-filter.languages-filter.ready-button'),
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: colorMain),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        fit: FlexFit.tight,
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.date,
                                          initialDateTime: _birthDate != null
                                              ? _birthDate
                                              : DateTime.utc(1990),
                                          minimumYear: 1900,
                                          maximumDate: DateTime.now().subtract(
                                              new Duration(days: 6576)),
                                          onDateTimeChanged: (DateTime value) {
                                            setState(() {
                                              _birthDate = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Text(
                          _birthDate != null
                              ? '${_birthDate.day}.${_birthDate.month}.${_birthDate.year}'
                              : translate(
                                  'enter-birthday-page.birthday-input-placeholder'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22.0),
                        ),
                      ),
                    ),
                    Text(
                      translate(
                          'enter-birthday-page.birthday-will-be-published-message'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
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
                      onPressed: _birthDate != null
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
    user.dateOfBirth = _birthDate;
    Navigator.pushNamed(context, Routes.select_languages);
  }
}
