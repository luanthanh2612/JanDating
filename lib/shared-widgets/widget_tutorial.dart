import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jan_app_flutter/constants/icons.dart';
import 'package:jan_app_flutter/constants//styles.dart';
import 'package:flutter_translate/global.dart';
import 'package:flutter_dash/flutter_dash.dart';

class WidgetTutorial extends StatefulWidget {
  dynamic callback;

  WidgetTutorial(this.callback);

  @override
  _WidgetTutorialState createState() => new _WidgetTutorialState();
}

class _WidgetTutorialState extends State<WidgetTutorial> {
  // Timer timer;
  dynamic user;
  bool viewed;

  @override
  void initState() {
    if (viewed == true) {
      widget.callback();
    } else {
      print('not viewed');
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        Container(
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: colorMain),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    child: Dash(
                        direction: Axis.vertical,
                        length: MediaQuery.of(context).size.height / 2 - 60,
                        dashLength: 10,
                        dashColor: colorMain),
                    alignment: Alignment.topCenter,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              10,
                              MediaQuery.of(context).size.height / 2 - 120,
                              10,
                              20),
                          child: Row(children: [
                            Text(translate('tutorial-screen.not-now'),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            Spacer(),
                            Text(translate('tutorial-screen.like'),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                        Container(
                            child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(
                                height: 60,
                                width: 60,
                                child: FlatButton(
                                    disabledColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: colorMain, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(100.0)),
                                    onPressed: () {},
                                    child: Icon(JanIcons.close,
                                        color: colorMain, size: 28)),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(
                                height: 60,
                                width: 60,
                                child: FlatButton(
                                  disabledColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: colorMain, width: 1),
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  child: Icon(JanIcons.like,
                                      color: colorMain, size: 28),
                                  padding: EdgeInsets.fromLTRB(0, 4, 4, 4),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 50,
                    left: MediaQuery.of(context).size.width / 2 -
                        (MediaQuery.of(context).size.width - 180) / 2 -
                        10,
                    child: Icon(JanIcons.swipes,
                        color: colorMain,
                        size: (MediaQuery.of(context).size.width - 180) / 2),
                  ),
                  Padding(
                    child: Column(
                      children: [
                        Dash(
                            direction: Axis.horizontal,
                            length: MediaQuery.of(context).size.width - 32,
                            dashLength: 10,
                            dashColor: colorMain),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: FlatButton(
                                  child: Row(
                                    children: [
                                      Text(translate('tutorial-screen.next'),
                                          style: TextStyle(
                                              color: colorMain,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      Icon(JanIcons.arrow_right_1,
                                          color: colorMain, size: 17)
                                    ],
                                  ),
                                  onPressed: () {
                                    widget.callback();
                                  },
                                ),
                              ),
                            ])
                      ],
                    ),
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height - 200),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
