import 'package:flutter/material.dart';
import 'package:jan_app_flutter/ui/profile/page_filters_location.dart';
import 'ui/home/home.dart';
import 'ui/auth/register/page_select_birthdate.dart';
import 'ui/auth/register/page_select_height.dart';
import 'ui/auth/register/page_select_languages.dart';
import 'ui/auth/register/page_select_photo.dart';
import 'ui/auth/page_login.dart';
import 'ui/auth/page_login_confirm.dart';
import 'ui/auth/register/page_select_gender.dart';
import 'ui/auth/register/page_select_name.dart';
import 'ui/profile/page_filters.dart';
import 'ui/profile/page_filters_language.dart';
import 'ui/profile/page_profile.dart';
import 'ui/profile/page_profile_languages.dart';
import 'ui/profile/page_settings.dart';
import 'ui/profile/page_store.dart';
import 'ui/splash/page_landing.dart';
import 'ui/splash/splash_screen.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String login_confirm = '/login_confirm';
  static const String select_gender = '/register/select_gender';
  static const String select_name = '/register/select_name';
  static const String select_birth = '/register/select_birth';
  static const String select_languages = '/register/select_languages';
  static const String select_height = '/register/select_height';
  static const String select_photo = '/register/select_photo';

  static const String home = '/home';
  static const String profile = '/profile';
  static const String profile_languages = '/profile/languages';
  static const String filters = '/filters';
  static const String filters_language = '/filters/language';
  static const String settings = '/settings';
  static const String store = '/store';
  static const String maps = '/maps';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    landing: (BuildContext context) => PageLanding(),
    login: (BuildContext context) => PageLogin(),
    login_confirm: (BuildContext context) => PageLoginConfirm(),
    select_gender: (BuildContext context) => PageSelectGender(),
    select_name: (BuildContext context) => PageSelectName(),
    select_birth: (BuildContext context) => PageSelectBirthDate(),
    select_languages: (BuildContext context) => PageSelectLanguages(),
    select_height: (BuildContext context) => PageSelectHeight(),
    select_photo: (BuildContext context) => PageSelectPhoto(),
    home: (BuildContext context) => HomeScreen(),
    profile: (BuildContext context) => PageProfile(),
    profile_languages: (BuildContext context) => PageProfileLanguages(),
    filters: (BuildContext context) => PageFilters(),
    filters_language: (BuildContext context) => PageFiltersLanguage(),
    settings: (BuildContext context) => PageSettings(),
    store: (BuildContext context) => StorePage(),
    maps : (BuildContext context) => PageFiltersLocation()
  };
}
