import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';
import 'package:jan_app_flutter/shared-widgets/widget_profile_photo.dart';
import 'package:jan_app_flutter/shared-widgets/widget_profile_photo_requirements.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:jan_app_flutter/constants/styles.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PageSelectPhoto extends StatefulWidget {
  @override
  _PageSelectPhotoState createState() => _PageSelectPhotoState();
}

class _PageSelectPhotoState extends State<PageSelectPhoto> {
  bool _isLoading = false;
  //dynamic user;
  //List<DocumentReference> _photos = [];

  showLoader(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

//  savePhotos() {
//    setState(() {
//      _photos = context.read<UserState>().photos;
//    });
//  }

  @override
  void initState() {
    super.initState();
//    user = context.read<UserState>();
//    user.addListener(savePhotos);
  }

  @override
  void dispose() {
//    user.removeListener(savePhotos);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final storeUser = authProvider.currentUser;

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              Align(
                alignment: FractionalOffset(0.5, 1),
                child: WidgetProfilePhotoRequirements(),
              ),
              Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Align(
                      alignment: FractionalOffset(0.5, 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          translate('add-photo-page.add-photo-text'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 15, left: 25, right: 25),
                    child: Text(
                      translate('add-photo-page.add-photo-description'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: WidgetProfilePhoto(
                      photos: [],
                      showLoader: showLoader,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              translate(
                                  'enter-phone-number-page.continue-button'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                              ),
                            ),
                            textColor: colorMain,
                            disabledTextColor: colorGrey,
                            onPressed: (storeUser.photos != null &&
                                    storeUser.photos.length > 0)
                                ? () => onSubmit(storeUser)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSubmit(UserModel user) async {
    showLoader(true);

    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    await firestoreDatabase.setUser(user);
    // user.photos.forEach((photo) async {
    //   await firestoreDatabase.setPhoto(photo, user.uid);
    // });

    showLoader(false);
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }
}
