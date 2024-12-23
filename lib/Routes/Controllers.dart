import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

class UserController extends ChangeNotifier {
  String _username;
  String _email;

  UserController(this._username, this._email);

  String get username => _username;
  String get email => _email;

  void updateUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }
  RxBool isLoggedIn = false.obs;
}