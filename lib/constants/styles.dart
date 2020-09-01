import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

Color get colorMain => Color(0xFF6F2D8D);
Color get colorGrey => Color(0xFF909090);
Color get colorGreyLight => Color(0xFFC0C0C0);

showErrorNotification(context, message) => showModalBottomSheet(
    context: context,
    shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.only(
        topLeft: const Radius.circular(30.0),
        topRight: const Radius.circular(30.0),
      ),
    ),
    builder: (context) {
      return Container(
        height: 200,
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset(0.5, 0.5),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            FlatButton(
              child: Text(
                translate('buttons.okay'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              textColor: colorMain,
              disabledTextColor: Colors.grey,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    });
