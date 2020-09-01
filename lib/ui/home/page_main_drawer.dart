import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/constants/icons.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  final dynamic currentState;
  final String city;
  final String country;
  final String profilePhoto;

  MainDrawer({
    Key key,
    @required this.currentState,
    @required this.city,
    @required this.country,
    @required this.profilePhoto,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => new _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Container(
              width: 130,
              height: 130,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    imageUrl: authProvider.currentUser.photoUrl,
                    placeholder: (context, url) => Center(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator(),
                        )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                '${Provider.of<AuthProvider>(context).currentUser.firstName}, ${(DateTime.now().difference(Provider.of<AuthProvider>(context).currentUser.dateOfBirth).inDays / 365).floor()}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            _addressText(widget.city, widget.country),
            _buildButtons(widget, widget.city, widget.country, context),
          ],
        ),
      ),
    );
  }
}

Widget _buildButtons(widget, city, country, context) {
  return new Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.only(top: 45),
    child: new Column(
      children: <Widget>[
        _drawFlatButtonWithIcons(
            widget,
            'side-menu.my-profile',
            JanIcons.my_profile,
            context,
            () => Navigator.pushNamed(context, Routes.profile)),
        _drawLine(),
        _drawFlatButtonWithIcons(
            widget,
            'side-menu.search-filter',
            JanIcons.search_filter,
            context,
            () => Navigator.pushNamed(context, Routes.filters)),
        _drawLine(),
        _drawFlatButtonWithIcons(
            widget,
            'side-menu.settings',
            JanIcons.tech_support,
            context,
            () => Navigator.pushNamed(context, Routes.settings)),
        _drawLine(),
        _drawFlatButtonWithIcons(widget, 'side-menu.store', JanIcons.store,
            context, () => Navigator.pushNamed(context, Routes.store)),
        _drawLine(),
        _drawFlatButtonWithIcons(widget, 'side-menu.about-application',
            JanIcons.about_application, context, () {}),
      ],
    ),
  );
}

Widget _addressText(city, country) {
  if (city != null && city.length > 0) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        '$city, $country',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: colorGrey,
        ),
      ),
    );
  } else {
    return Text('');
  }
}

Widget _drawLine() {
  return Padding(
    padding: EdgeInsets.fromLTRB(20, 0, 55, 0),
    child: Container(
      height: 1,
      color: colorGreyLight,
    ),
  );
}

Widget _drawFlatButtonWithIcons(widget, name, icon, context, callback) {
  return new FlatButton(
    padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
    onPressed: () {
      callback();
      widget.currentState.openEndDrawer();
    },
    child: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(icon, color: Colors.purple, size: 16),
        ),
        new Text(
          translate(name),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 13,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Icon(
            JanIcons.arrow_right,
            size: 13,
            color: colorGrey,
          ),
        ),
      ],
    ),
  );
}
