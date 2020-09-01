import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jan_app_flutter/models/user_model.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';

int get default_distance => 300;

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering
}
/*
The UI will depends on the Status to decide which screen/action to be done.

- Uninitialized - Checking user is logged or not, the Splash Screen will be shown
- Authenticated - User is authenticated successfully, Home Page will be shown
- Authenticating - Sign In button just been pressed, progress bar will be shown
- Unauthenticated - User is not authenticated, login page will be shown
- Registering - User just pressed registering, progress bar will be shown

Take note, this is just an idea. You can remove or further add more different
status for your UI or widgets to listen.
 */

class AuthProvider extends ChangeNotifier {
  //Firebase Auth object
  FirebaseAuth _auth;
  FirebaseAuth get auth => _auth;
  Geoflutterfire _geo;
  Geoflutterfire get geo => _geo;

  String countryCode = 'RU';
  String verificationId;
  String phoneNumber;
  String address;
  GeoFirePoint location;

  //Default status
  Status _status = Status.Uninitialized;
  Status get status => _status;

  Stream<AuthUser> get user => _auth.authStateChanges().map(_userFromFirebase);

  UserModel currentUser;

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;
    _geo = Geoflutterfire();

    //listener for authentication changes such as user sign in and sign out
    _auth.authStateChanges().listen(onAuthStateChanged);

    //create cloud store user
  }

  Future<UserModel> getCurrentUser(
      FirestoreDatabase firestoreDatabase, User firebaseUser) async {
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser;
    }

    if (firebaseUser != null) {
      UserModel userModel =
          await firestoreDatabase.userFuture(userId: firebaseUser.uid);
      if (userModel == null) {
        userModel = UserModel(
          uid: firebaseUser.uid,
          phoneNumber: firebaseUser.phoneNumber,
          address: address,
          position: location.data,
          maxDistance: default_distance,
        );
      }
      this.currentUser = userModel;
      return userModel;
    } else {
      return null;
    }
  }

  //Create user object based on the given FirebaseUser
  AuthUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }

    if (currentUser == null) {
      currentUser = UserModel(
        uid: user.uid,
        phoneNumber: user.phoneNumber,
        address: address,
        position: location.data,
        maxDistance: default_distance,
      );
    }

    return AuthUser(
      uid: user.uid,
      phoneNumber: user.phoneNumber,
    );
  }

  //Method to detect live auth changes such as user sign in and sign out
  Future<void> onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _userFromFirebase(firebaseUser);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  void setCountryCode(code) {
    countryCode = code;
    notifyListeners();
  }

  void setVerificationId(verificationId) {
    this.verificationId = verificationId;
    notifyListeners();
  }

  void setLocation(Placemark pm) {
    countryCode = pm.isoCountryCode;
    location = geo.point(
        latitude: pm.position.latitude, longitude: pm.position.longitude);
    address =
        "${pm.locality} ${pm.subLocality} ${pm.subAdministrativeArea}\n ${pm.country} ,${pm.postalCode}";
    notifyListeners();
  }

  Future<void> verifyPhone(
      String phoneNumber,
      PhoneCodeSent smsOTPSent,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout) async {
    this.phoneNumber = phoneNumber;

    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: smsOTPSent,
        timeout: const Duration(
          seconds: 30,
        ),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (ex) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw ex;
    }
  }

  Future<void> verifyPhoneAgain(
      PhoneCodeSent smsOTPSent,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: smsOTPSent,
        timeout: const Duration(
          seconds: 30,
        ),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (ex) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw ex;
    }
  }

  Future<User> verifyOTP(String otp) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final result = await _auth.signInWithCredential(credential);
      final User firebaseUser = result.user;

      if (firebaseUser.uid != "") {
        _status = Status.Authenticated;
        notifyListeners();
      }

      return firebaseUser;
    } catch (ex) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw ex;
    }
  }

  //Method to handle user signing out
  Future signOut() async {
    _auth.signOut();
    currentUser = null;
    location = null;
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  //Method for new user registration using email and password
  Future<AuthUser> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      _status = Status.Registering;
      notifyListeners();
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return _userFromFirebase(result.user);
    } catch (e) {
      print("Error on the new user registration = " + e.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  //Method to handle user sign in using email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("Error on the sign in = " + e.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

@immutable
class AuthUser {
  const AuthUser({
    @required this.uid,
    this.phoneNumber,
  }) : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String phoneNumber;

  factory AuthUser.fromFirebaseUser(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return AuthUser(
      uid: user.uid,
      phoneNumber: user.phoneNumber,
    );
  }
}
