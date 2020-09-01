import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:provider/provider.dart';
import 'package:jan_app_flutter/constants/styles.dart';

class PageSelectName extends StatefulWidget {
  @override
  _PageSelectNameState createState() => _PageSelectNameState();
}

class _PageSelectNameState extends State<PageSelectName> {
  bool _isValidText = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.addListener(textOnChange);
    // TODO: implement initState
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
                    translate('enter-first-name-page.enter-your-first-name'),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
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
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: translate(
                              'enter-first-name-page.first-name-input-placeholder'),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22.0),
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                      ),
                    ),
                    Text(
                      translate('enter-first-name-page.anonymity-message'),
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
                      onPressed: _isValidText
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

  void textOnChange() {
    String text = _nameController.text;
    bool temp = false;
    // Sam wants this
    if (text.length >= 2) {
      temp = true;
    } else {
      temp = false;
    }
    setState(() {
      _isValidText = temp;
    });
  }

  void onSubmit(UserModel user) async {
    user.firstName = _nameController.text;
    Navigator.pushNamed(context, Routes.select_birth);
  }
}
