import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:flutter_translate/global.dart';

class WidgetTimer extends StatefulWidget {
  @override
  _WidgetTimerState createState() => new _WidgetTimerState();
}

class _WidgetTimerState extends State<WidgetTimer> {
  Duration swipesResetDuration = Duration(hours: 0);

  @override
  void initState() {
//    swipesResetDuration = Duration(
//        seconds: context
//            .read<UserState>()
//            .swipesResetDateTime
//            .difference(DateTime.now())
//            .inSeconds);
//    super.initState();
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    15, MediaQuery.of(context).size.height / 5, 15, 30),
                child: Text(
                  translate('timer.title'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff4F4F4F),
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CountdownFormatted(
                duration: swipesResetDuration,
                onFinish: () async {
//                  context.read<UserState>().resetSwipesCount();
//                  await context
//                      .read<UserState>()
//                      .userReference
//                      .reference
//                      .setData(context.read<UserState>().profile);
                },
                builder: (BuildContext ctx, String remaining) {
                  return Text(
                    remaining,
                    style: TextStyle(
                      fontSize: 40,
                      color: colorMain,
                      fontWeight: FontWeight.bold,
                    ),
                  ); // 01:00:00
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 4),
                child: MaterialButton(
                  minWidth: 210,
                  height: 40,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Color(0xff00E291),
                  child: Text(
                    translate('timer.button'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => {Navigator.pushNamed(context, '/app/store')},
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
