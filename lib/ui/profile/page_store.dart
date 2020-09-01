import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/shared-widgets/widget_store_slider.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => new _StorePageState();
}

class _StorePageState extends State<StorePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(translate('side-menu.store')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          StoreSlider(),
        ],
      ),
    );
  }
}
