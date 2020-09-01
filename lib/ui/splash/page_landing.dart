import 'package:flutter/material.dart';

import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';

final Geolocator _geolocator = Geolocator();

class PageLanding extends StatefulWidget {
  @override
  _PageLandingState createState() => new _PageLandingState();
}

class _PageLandingState extends State<PageLanding> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/login-background.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Container(
              child: OutlineButton(
                child: Text(
                  translate("login-page.sign-in"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                onPressed: () => onLoginRedirect(authProvider),
                textColor: Colors.white,
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
              ),
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 60.0),
            ),
          ),
        ],
      ),
    );
  }

  onLoginRedirect(authProvider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final position = await Future.any([
        _geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.lowest,
        ),
        Future.delayed(const Duration(seconds: 15))
      ]);

      if (position != null) {
        final List<Placemark> place =
            await _geolocator.placemarkFromPosition(position);
        authProvider.setLocation(place[0]);
      }
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.pushNamed(context, Routes.login);
  }
}
