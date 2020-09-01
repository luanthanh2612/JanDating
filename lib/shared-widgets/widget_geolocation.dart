import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:app_settings/app_settings.dart';

final Geolocator _geolocator = Geolocator();

class WidgetGeolocation extends StatefulWidget {
  dynamic callback;

  WidgetGeolocation(this.callback);

  @override
  _WidgetGeolocationState createState() => new _WidgetGeolocationState();
}

class _WidgetGeolocationState extends State<WidgetGeolocation> {
  Timer timer;

  setGeolocation() async {
    var geolocation = await _geolocator.checkGeolocationPermissionStatus();
    if (geolocation == GeolocationStatus.granted) {
      timer.cancel();
      widget.callback();
    } else {
      print(geolocation);
    }
  }

  @override
  void initState() {
    timer =
        new Timer.periodic(Duration(seconds: 5), (Timer t) => setGeolocation());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  translate('geolocation-screen.title'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff4F4F4F),
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Image.asset(
                  'assets/images/geolocation.png',
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: MaterialButton(
                  minWidth: 210,
                  height: 40,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Color(0xff00E291),
                  child: Text(
                    translate('geolocation-screen.turn-on'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => {AppSettings.openLocationSettings()},
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: translate('geolocation-screen.description.part1'),
                        style: TextStyle(
                          color: Color(0xff4F4F4F),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      TextSpan(
                        text: ' Jan ',
                        style: TextStyle(
                          color: Color(0xff4F4F4F),
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      TextSpan(
                        text: translate('geolocation-screen.description.part2'),
                        style: TextStyle(
                          color: Color(0xff4F4F4F),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
