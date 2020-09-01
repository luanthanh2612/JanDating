import 'package:flutter/foundation.dart';

class AuthorizationState with ChangeNotifier {
  String _countryCode = 'RU';
  String _verificationCode = '';
  String _phoneNumber = '';

  String get countryCode => _countryCode;

  String get verificationCode => _verificationCode;

  String get phoneNumber => _phoneNumber;

  void setCountryCode(code) {
    _countryCode = code;
    notifyListeners();
  }

  void setVerificationCode(code) {
    _verificationCode = code;
    notifyListeners();
  }

  void setPhoneNumber(value) {
    _phoneNumber = value;
    notifyListeners();
  }
}
