import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jan_app_flutter/constants//styles.dart';
import 'package:flutter_translate/global.dart';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';

class WidgetNoConnection extends StatefulWidget {
  dynamic callback;
  WidgetNoConnection(this.callback);

  @override
  _WidgetNoConnectionState createState() => new _WidgetNoConnectionState();
}

class _WidgetNoConnectionState extends State<WidgetNoConnection> {
  Timer timer;

  setConnection() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        timer.cancel();
        widget.callback();
      } else {
        print('no  connectivity');
      }
    });
  }

  @override
  void initState() {
    timer =
        new Timer.periodic(Duration(seconds: 5), (Timer t) => setConnection());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.0),
                      border: Border.all(color: colorMain),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 50, 50, 20),
                  child: Text(translate('no-internet-screen.title'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff4F4F4F),
                          fontSize: 21,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  child: Image.asset(
                    'assets/images/no-internet.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: MaterialButton(
                    minWidth: 200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    color: Color(0xff00E291),
                    child: Text(translate('no-internet-screen.turn-on'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    onPressed: () => {AppSettings.openWIFISettings()},
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
