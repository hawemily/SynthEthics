import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CurrentUser {
  User _user;
  GoogleSignIn _googleSignIn;
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

  setGoogleSignIn(GoogleSignIn gSI) {
    _googleSignIn = gSI;
  }

  googleSignIn() {
    return _googleSignIn;
  }

  getUID() {
    return _user.uid;
  }

  CurrentUser._internal();
}
