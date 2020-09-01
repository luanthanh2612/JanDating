import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:provider/provider.dart';
import 'package:jan_app_flutter/constants/styles.dart';

class PageSelectHeight extends StatefulWidget {
  @override
  _PageSelectHeightState createState() => _PageSelectHeightState();
}

class _PageSelectHeightState extends State<PageSelectHeight> {
  int _height;
  List _heightOptions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    for (var i = 100; i < 241; i++) {
      var realFeet = ((i * 0.393700) / 12);
      var feet = (realFeet).floor();
      var inches = ((realFeet - feet) * 12).round();

      _heightOptions
          .add('$i ${translate("enter-height-page.cm")} ($feet\'$inches")');
    }

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
                    translate('enter-height-page.enter-height-text'),
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
                                        child: CupertinoPicker(
                                          scrollController:
                                              FixedExtentScrollController(
                                                  initialItem: _height != null
                                                      ? _height
                                                      : 70),
                                          itemExtent: 45.0,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              _height = index;
                                            });
                                          },
                                          children: new List<Widget>.generate(
                                            _heightOptions.length,
                                            (int index) {
                                              return new Center(
                                                child: new Text(
                                                    '${_heightOptions[index]}'),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Text(
                          _height != null
                              ? '${_heightOptions[_height]}'
                              : translate(
                                  'enter-height-page.height-input-placeholder'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22.0),
                        ),
                      ),
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
                      onPressed: _height != null
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
    user.height = _height + 100;
    Navigator.pushNamed(context, Routes.select_photo);
  }
}
