import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';
import 'package:jan_app_flutter/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:jan_app_flutter/constants/styles.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Firebase packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool _isLoading = false;
  String _countryCode;
  final TextEditingController _phoneNumberController = TextEditingController();
  double height = double.infinity;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    _countryCode = authProvider.countryCode;

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
                child: FlatButton(
                  child: Text(
                    translate('enter-phone-number-page.user-agreement'),
                    style: TextStyle(
                      color: colorGrey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    print('AGREEMENT');
                  },
                ),
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
                          translate(
                              'enter-phone-number-page.enter-phone-number-text'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Row(
                              children: <Widget>[
                                CountryCodePicker(
                                  textStyle: TextStyle(
                                    fontSize: 22.0,
                                  ),
                                  dialogTextStyle: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                  searchStyle: TextStyle(
                                    fontSize: 22.0,
                                  ),
                                  searchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(25.0),
                                      ),
                                    ),
                                  ),
                                  builder: (CountryCode code) {
                                    return Container(
                                      padding:
                                          EdgeInsets.fromLTRB(25, 10, 10, 10),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            code.flagUri,
                                            package: 'country_code_picker',
                                            width: 35,
                                          ),
                                          Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    );
                                  },
                                  favorite: ['AM', 'US', 'RU'],
                                  initialSelection: _countryCode,
                                  onInit: (code) => SchedulerBinding.instance
                                      .addPostFrameCallback(
                                    (_) => setState(() {
                                      if (_countryCode != null) {
                                        _phoneNumberController.text =
                                            formatAsPhoneNumber(code.dialCode);
                                      }
                                    }),
                                  ),
                                  onChanged: (CountryCode code) {
                                    setState(() {
                                      _phoneNumberController.text =
                                          formatAsPhoneNumber(code.dialCode);
                                    });
                                  },
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    style: TextStyle(fontSize: 22.0),
                                    keyboardType: TextInputType.phone,
                                    controller: _phoneNumberController,
                                    inputFormatters: [
                                      PhoneInputFormatter(
                                        onCountrySelected: _onCountrySelected,
                                      )
                                    ],
                                  ),
                                )
                              ],
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
                              translate(
                                  'enter-phone-number-page.continue-button'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                              ),
                            ),
                            textColor: colorMain,
                            disabledTextColor: colorGrey,
                            onPressed:
                                isPhoneValid(_phoneNumberController.text) &&
                                        _phoneNumberController.text.length > 5
                                    ? () => {onLogin(authProvider)}
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

  void onLogin(AuthProvider authProvider) async {
    setState(() {
      _isLoading = true;
    });

    print('+${toNumericString(_phoneNumberController.text)}');

    try {
      authProvider.verifyPhone(
        '+${toNumericString(_phoneNumberController.text)}',
        smsOTPSent,
        verificationCompleted,
        verificationFailed,
        codeAutoRetrievalTimeout,
      );
    } catch (ex) {
      setState(() {
        _isLoading = false;
      });
      showErrorNotification(
        context,
        ex.toString(),
      );
    }
  }

  void _onCountrySelected(PhoneCountryData countryData) {
    setState(() {
      _countryCode = countryData != null ? countryData.countryCode : null;
    });
  }

  Future<void> verificationCompleted(AuthCredential phoneAuthCredential) async {
    final User user =
        (await _auth.signInWithCredential(phoneAuthCredential)).user;

    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = userData.data();
      var initialRoute = '/register/select-gender';
      if (userData.data != null && data['gender'] != null) {
        //= UserState.fromDocument(userData);
        initialRoute = '/app/main';
      }

      Navigator.pushNamedAndRemoveUntil(
          context, initialRoute, (route) => false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void verificationFailed(FirebaseAuthException authException) {
    setState(() {
      _isLoading = false;
    });

    print(authException.code);

    showErrorNotification(
        context,
        authException.code == 'invalidCredential'
            ? translate('error-message.invalid-phone-number')
            : translate('error-message.too-many-requests-error'));
  }

  void smsOTPSent(String verificationId, [int forceResendingToken]) async {
    context.read<AuthProvider>().verificationId = verificationId;

    setState(() {
      _isLoading = false;
    });

    Navigator.pushNamed(context, Routes.login_confirm);
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    context.read<AuthProvider>().setVerificationId(verificationId);
  }
}
