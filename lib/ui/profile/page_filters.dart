import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/constants/icons.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/constants/thumb.dart';
import 'package:jan_app_flutter/models/filters.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:jan_app_flutter/routes.dart';

class PageFilters extends StatefulWidget {
  @override
  _PageFiltersState createState() => new _PageFiltersState();
}

class _PageFiltersState extends State<PageFilters> {
  int _range = default_distance;
  RangeValues _ageValues = RangeValues(18.0, 99.0);
  RangeValues _heightValues = RangeValues(140.0, 220.0);
  String _preferredLanguage;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic filters;

  setLanguage() {
    setState(() {
      _preferredLanguage = filters.language;
    });
  }

  @override
  void initState() {
    filters = context.read<FiltersState>();
    filters.addListener(setLanguage);

    _getFilters().then((result) {
    
      setState(() {
        //_range = result[0];
        _heightValues = result[1];
        _ageValues = result[2];
        _preferredLanguage = result[3];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    filters.removeListener(setLanguage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _range = authProvider.currentUser.maxDistance;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('side-menu.search-filter')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            firestoreDatabase.setUser(authProvider.currentUser);
            _saveFilters();
            filters.removeListener(setLanguage);
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Text(
                  translate('search-filter.filters.distance.label'),
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                child: Text(
                  '${_getDistance(_range).toString()} ${translate('search-filter.filters.distance.value-label')}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: colorMain,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 0.7,
                thumbShape: CircleThumbShape(thumbRadius: 10),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 15.0),
              ),
              child: Slider(
                  min: 1,
                  max: 401,
                  value: _range.toDouble(),
                  activeColor: const Color(0xff6F2D8D),
                  inactiveColor: Colors.grey,
                  onChanged: (value) async {
                    //firestoreDatabase.setUser(authProvider.currentUser);
                    setState(() {
                      _range = value.toInt();
                      authProvider.currentUser.setMaxDistance(_range);
                    });
                  }),
            ),
          ),
          _drawLine(),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                translate('Choose location'),
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _drawFlatButton("Los Angeles, USA",()=>Navigator.pushNamed(context, Routes.maps)),
          _drawLine(),

          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Text(
                  translate('search-filter.filters.age.label'),
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                child: Text(
                  '${_getAge(_ageValues.start.round(), _ageValues.end.round())} ${translate('search-filter.filters.age.value-label')}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: colorMain,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 0.7,
                rangeThumbShape: CircleRangeThumbShape(thumbRadius: 10),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 15.0),
              ),
              child: RangeSlider(
                  values: _ageValues,
                  min: 18.0,
                  max: 100.0,
                  activeColor: const Color(0xff6F2D8D),
                  inactiveColor: Colors.grey,
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      _ageValues = value;
                    });
                  }),
            ),
          ),
          _drawLine(),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Text(
                  translate('search-filter.filters.height.label'),
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                child: Text(
                  '${_getHeight(_heightValues.start.round(), _heightValues.end.round())} ${translate('search-filter.filters.height.value-label')}',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: colorMain,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 0.7,
                rangeThumbShape: CircleRangeThumbShape(thumbRadius: 10),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 15.0),
              ),
              child: RangeSlider(
                  values: _heightValues,
                  min: 100.0,
                  max: 220.0,
                  activeColor: colorMain,
                  inactiveColor: colorGreyLight,
                  onChanged: (value) {
                    setState(() {
                      _heightValues = value;
                    });
                  }),
            ),
          ),
          _drawLine(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                translate('search-filter.language-knowing-text'),
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _drawFlatButton("Nothing selected",()=>Navigator.pushNamed(context,Routes.filters_language))
        ],
      ),
    );
  }

  Widget _drawLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 0.5,
        color: colorGreyLight,
      ),
    );
  }

  String _getDistance(distance) {
    if (distance > 200) {
      return '200+';
    } else {
      return distance.toString();
    }
  }

  String _getAge(min, max) {
    if (max > 99) {
      return min.toString() + ' - ' + '99';
    } else {
      return min.toString() + ' - ' + max.toString();
    }
  }

  String _getHeight(min, max) {
    if (max > 220) {
      return min.toString() + ' - ' + '220';
    } else {
      return min.toString() + ' - ' + max.toString();
    }
  }

  Widget _drawFlatButton(String title,callback) {
    return new FlatButton(
      onPressed: () {
        callback();
        //print("Hello");
//        Navigator.pushNamed(context, '/app/filters/language',
//            arguments: _preferredLanguage);
      },
      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Row(
        children: <Widget>[
          new Text(
            _preferredLanguage != null
                ? translate('languages.$_preferredLanguage')
                : title,
            style: TextStyle(color: colorGrey, fontSize: 15),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Icon(JanIcons.arrow_right, size: 16, color: colorMain),
          ),
        ],
      ),
    );
  }

  _saveFilters() {
    //context.read<FiltersState>().setDistance(_range.toInt());
    context
        .read<FiltersState>()
        .setAge(_ageValues.start.toInt(), _ageValues.end.toInt());
    context
        .read<FiltersState>()
        .setHeight(_heightValues.start.toInt(), _heightValues.end.toInt());
  }

  _getFilters() async {
    context.read<FiltersState>().getFiltersFromMemory();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int distance = (prefs.getInt('distance') ?? 201);
    int minHeight = (prefs.getInt('minHeight') ?? 140);
    int maxHeight = (prefs.getInt('maxHeight') ?? 220);
    int minAge = (prefs.getInt('minAge') ?? 18);
    int maxAge = (prefs.getInt('maxAge') ?? 99);
    String language = (prefs.getString('language'));
    var height = RangeValues(minHeight.toDouble(), maxHeight.toDouble());
    var age = RangeValues(minAge.toDouble(), maxAge.toDouble());

    return [distance, height, age, language];
  }
}
