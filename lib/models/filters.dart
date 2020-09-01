import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiltersState with ChangeNotifier {
  int minAge;
  int maxAge;
  int minHeight;
  int maxHeight;
  int distance;
  String language;
  double longitude;
  double latitude;



  void setAge(min, max) {
    minAge = min;
    maxAge = max;
    _saveAgeFilter(min, max);
  }

  void setHeight(min, max) {
    minHeight = min;
    maxHeight = max;
    _saveHeightFilter(min, max);
  }

  void setDistance(range) {
    distance = range;
    _saveDistanceFilter(range);
  }

  void setLanguage(preferredLanguage) {
    language = preferredLanguage;
    _saveLanguageFilter(preferredLanguage);
    notifyListeners();
  }

  _saveAgeFilter(min, max) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('minAge', min);
    await prefs.setInt('maxAge', max);
  }

  _saveLatLng(LatLng point) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', point.latitude);
    await prefs.setDouble('longitude', point.longitude);

  }

  _saveHeightFilter(min, max) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('minHeight', min);
    await prefs.setInt('maxHeight', max);
  }

  _saveDistanceFilter(range) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('distance', range);
  }

  _saveLanguageFilter(language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  getFiltersFromMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    minAge = prefs.getInt('minAge');
    maxAge = prefs.getInt('maxAge');
    minHeight = prefs.getInt('minHeight');
    maxHeight = prefs.getInt('maxHeight');
    distance = prefs.getInt('distance');
    language = prefs.getString('language');
    latitude = prefs.getDouble('latitude');
    longitude = prefs.getDouble('longitude');
  }
}
