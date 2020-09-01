import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/ui/liked_by/page_liked_by_people.dart';
import 'package:jan_app_flutter/ui/home/page_main_drawer.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/shared-widgets/widget_geolocation.dart';
import 'package:jan_app_flutter/shared-widgets/widget_no_connection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jan_app_flutter/ui/threads/page_threads.dart';
import 'package:provider/provider.dart';
import 'page_main_search.dart';

final Geolocator _geolocator = Geolocator();

List likedByList = [];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool showLocationErrorDialog = false;
  bool showConnectionErrorDialog = false;
  String _country = '...';
  String _city = '...';
  String _profilePhoto;

  @override
  void initState() {
    _getConnection();
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final UserModel currentUser = authProvider.currentUser;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        drawer: MainDrawer(
          currentState: scaffoldKey.currentState,
          country: _country,
          city: _city,
          profilePhoto: _profilePhoto,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: TabBar(
                  labelColor: colorMain,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(icon: Icon(Icons.content_copy)),
                    Tab(icon: Icon(Icons.favorite)),
                    Tab(icon: Icon(Icons.message)),
                  ],
                ),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                MainPageSearch(),
                LikedByPeople(),
                ThreadsScreen(currentUser, [currentUser, currentUser],
                    [currentUser, currentUser]),
              ],
            ),
            showConnectionErrorDialog == true
                ? WidgetNoConnection(() => _getConnection())
                : Container(),
            showLocationErrorDialog == true
                ? WidgetGeolocation(() => _getCurrentLocation())
                : Container(),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest)
        .then((position) async {
      if (position != null) {
        final List<Placemark> place =
            await _geolocator.placemarkFromPosition(position);

        setState(() {
          _country = place.first.country;
          _city = place.first.locality;
          showLocationErrorDialog = false;
        });
      }
    }).catchError((onError) {
      setState(() {
        showLocationErrorDialog = true;
      });
    });
  }

  _getConnection() {
    Connectivity().checkConnectivity().then((value) => {
          if (value == ConnectivityResult.none)
            {
              setState(() {
                showConnectionErrorDialog = true;
              })
            }
          else
            {
              setState(() {
                showConnectionErrorDialog = false;
              })
            }
        });
  }

  _getProfilePhoto() async {
    //_profilePhotoRef = context.watch<UserState>().photos[0];
    //final photo = await context.watch<UserState>().photos[0].get();
//    setState(() {
//      _profilePhoto = photo.data['url'];
//    });
//    precacheImage(NetworkImage(photo.data['url']), context);
  }
}
