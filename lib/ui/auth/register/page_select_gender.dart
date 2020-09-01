import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:provider/provider.dart';
import 'package:jan_app_flutter/constants/styles.dart';

class PageSelectGender extends StatefulWidget {
  @override
  _PageSelectGenderState createState() => _PageSelectGenderState();
}

class _PageSelectGenderState extends State<PageSelectGender> {
  List<String> _genders = ['female', 'male'];
  int _selectedGender = -1;

  @override
  void initState() {
    super.initState();
  }

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
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/landing');
              }
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
                    translate('select-gender-page.your-gender-text'),
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
                child: ListView.builder(
                  itemCount: _genders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedGender = index),
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20.0),
                        decoration: BoxDecoration(
                          color: (_selectedGender == index)
                              ? colorMain
                              : Colors.transparent,
                          border: Border.all(
                            width: 2,
                            color: colorMain,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Text(
                          translate('select-gender-page.${_genders[index]}'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22.0,
                              color: (_selectedGender == index)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    );
                  },
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
                      onPressed: _selectedGender == -1
                          ? null
                          : () => onSubmit(authProvider.currentUser),
                    )
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
    user.gender = _genders[_selectedGender];
    Navigator.pushNamed(context, Routes.select_name);
  }
}
