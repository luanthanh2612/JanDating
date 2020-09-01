import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/constants/styles.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:jan_app_flutter/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PageLoginConfirm extends StatefulWidget {
  @override
  _PageLoginConfirmState createState() => _PageLoginConfirmState();
}

class _PageLoginConfirmState extends State<PageLoginConfirm> {
  bool _isLoading = false;
  bool _isValidText = false;
  Timer _timer;
  int _codeResend = 0;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    print(context.read<AuthProvider>().countryCode);
    _codeController.addListener(textOnChange);
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
          body: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Align(
                  alignment: FractionalOffset(0.5, 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      translate(
                          'enter-verification-code-page.enter-verification-code-text'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: colorMain,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: InputDecoration(border: InputBorder.none),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22.0),
                          keyboardType: TextInputType.number,
                          controller: _codeController,
                        ),
                      ),
                      Text(
                        translate(
                            'enter-verification-code-page.code-was-sent-text'),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        authProvider.phoneNumber,
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15.0),
                          child: _codeResend > 0
                              ? Text(translate(
                                      'enter-verification-code-page.resend-code-retry-in') +
                                  ' $_codeResend')
                              : Text(
                                  translate(
                                      'enter-verification-code-page.resend-code'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                          onPressed: _codeResend > 0
                              ? null
                              : () => verifyPhoneNumber(authProvider),
                        ),
                      ),
                    ],
                  ),
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
                          translate('enter-phone-number-page.continue-button'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                          ),
                        ),
                        textColor: colorMain,
                        disabledTextColor: colorGrey,
                        onPressed:
                            _isValidText ? () => verifyOTP(authProvider) : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void textOnChange() {
    String text = _codeController.text;
    bool temp = false;
    if (text.length > 3) {
      temp = true;
    } else {
      temp = false;
    }
    setState(() {
      _isValidText = temp;
    });
  }

  void onStartCountdown() {
    const oneSec = const Duration(seconds: 1);
    _codeResend = 30;
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_codeResend < 1) {
            timer.cancel();
          } else {
            _codeResend = _codeResend - 1;
          }
        },
      ),
    );
  }

  verifyPhoneNumber(AuthProvider authProvider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await authProvider.verifyPhoneAgain(
        (String verificationId, [int forceResendingToken]) {},
        (_) {},
        (FirebaseAuthException error) {},
        (String verificationId) {},
      );
    } catch (ex) {
      showErrorNotification(
        context,
        ex.toString(),
      );
    }

    onStartCountdown();

    setState(() {
      _isLoading = false;
    });
  }

  verifyOTP(AuthProvider authProvider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // verify sms code
      final firebaseUser = await authProvider.verifyOTP(_codeController.text);

      // stop loading
      setState(() {
        _isLoading = false;
      });

      final firestoreDatabase =
          Provider.of<FirestoreDatabase>(context, listen: false);
      final currentUser =
          await authProvider.getCurrentUser(firestoreDatabase, firebaseUser);

      if (currentUser != null && currentUser.gender != null) {
        Navigator.popAndPushNamed(context, Routes.home);
      } else {
        firestoreDatabase.setUser(authProvider.currentUser);
        Navigator.popAndPushNamed(context, Routes.select_gender);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      showErrorNotification(
          context, translate('error-message.sms-code-expired-error'));
    }
  }
}
