import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_text_color/flutter_statusbar_text_color.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/constants/app_themes.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/providers/theme_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/alcohol.dart';
import 'models/education.dart';
import 'models/filters.dart';
import 'models/kids.dart';
import 'models/languages.dart';
import 'models/marital_status.dart';
import 'models/occupation.dart';
import 'models/smoking.dart';
import 'models/sport.dart';
import 'models/user_model.dart';
import 'models/zodiac_signs.dart';

class JanApp extends StatelessWidget {
  const JanApp({Key key, this.firestoreDatabase}) : super(key: key);

  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirestoreDatabase firestoreDatabase;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    final authService = Provider.of<AuthProvider>(context, listen: false);
    return Consumer<ThemeProvider>(
      builder: (_, themeProviderRef, __) {
        //{context, data, child}
        return LocalizationProvider(
          state: LocalizationProvider.of(context).state,
          child: FutureBuilder(
            future: Future.wait(
              [
                Connectivity().checkConnectivity(),
                authService.getCurrentUser(firestoreDatabase, null),
              ],
            ),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return Material(
                  child: Container(),
                );
              }

              if (snapshot.data[0] == ConnectivityResult.none) {
                // No Connection Popup
                print('// No Connection Popup');
              }

              UserModel userModel = snapshot.data[1];
              var initialRoute = Routes.landing;
              if (userModel != null) {
                if (userModel.gender != null) {
                  initialRoute = Routes.home;
                } else {
                  initialRoute = Routes.select_gender;
                }
              } else {
                initialRoute = Routes.landing;
              }

              return MultiProvider(
                providers: [
                  Provider<FirestoreDatabase>(
                    create: (context) => firestoreDatabase,
                  ),
                  ChangeNotifierProvider(create: (_) => LanguagesState()),
                  ChangeNotifierProvider(create: (_) => EducationState()),
                  ChangeNotifierProvider(create: (_) => OccupationState()),
                  ChangeNotifierProvider(create: (_) => SmokingState()),
                  ChangeNotifierProvider(create: (_) => AlcoholState()),
                  ChangeNotifierProvider(create: (_) => SportState()),
                  ChangeNotifierProvider(create: (_) => MaritalStatusState()),
                  ChangeNotifierProvider(create: (_) => KidsState()),
                  ChangeNotifierProvider(create: (_) => ZodiacSignsState()),
                  ChangeNotifierProvider(create: (_) => FiltersState()),
                ],
                child: OverlaySupport(
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    //List of all supported locales
                    supportedLocales: localizationDelegate.supportedLocales,
                    locale: localizationDelegate.currentLocale,
                    //These delegates make sure that the localization data for the proper language is loaded
                    localizationsDelegates: [
                      //A class which loads the translations from JSON files
                      localizationDelegate,
                      //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      //Built-in localization for text direction LTR/RTL
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    initialRoute: initialRoute,
                    routes: Routes.routes,
                    navigatorObservers: [StatusBarTextRouteObserver()],
                    theme: AppThemes.lightTheme,
                    /*
                    darkTheme: AppThemes.darkTheme,
                    themeMode: themeProviderRef.isDarkModeOn
                        ? ThemeMode.dark
                        : ThemeMode.light,

                    */
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class StatusBarTextRouteObserver extends NavigatorObserver {
  Timer _timer;

  _setStatusBarTextColor(Route route) {
    _timer?.cancel();

    _timer = Timer(Duration(milliseconds: 200), () async {
      try {
        if (route.settings.name == '/landing') {
          await FlutterStatusbarTextColor.setTextColor(
            FlutterStatusbarTextColor.light,
          );
        } else {
          await FlutterStatusbarTextColor.setTextColor(
            FlutterStatusbarTextColor.dark,
          );
        }
      } catch (_) {}
    });
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    _setStatusBarTextColor(route);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    _setStatusBarTextColor(previousRoute);
  }
}
