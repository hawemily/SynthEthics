import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  User _user;
  static CurrentUser _instance;

  static CurrentUser getInstance() {
    if (_instance == null) {
      _instance = CurrentUser._internal();
    }
    return _instance;
  }

  setUser(User user) {
    _user = user;
  }

  getUID() {
    return _user.uid;
  }

  CurrentUser._internal();
}
