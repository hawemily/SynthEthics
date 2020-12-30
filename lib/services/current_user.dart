import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:synthetics/screens/login/sign_in_method_enum.dart';

class CurrentUser {
  User _user;
  String _firstname;
  String _lastname;
  String _initials;
  String _bgImage;
  GoogleSignIn _googleSignIn;
  SignInMethod _signInMethod = SignInMethod.EmailPassword;
  static CurrentUser _instance;

  static CurrentUser getInstance() {
    if (_instance == null) {
      _instance = CurrentUser._internal();
    }
    return _instance;
  }

  setUser(User user) {
//    print("setting user");
//    print("uid: ${user.uid}");
    _user = user;
    if (user.photoURL != null && user.photoURL != "") {
      _bgImage = user.photoURL;
      print("setting bgImage: $_bgImage");
    }
  }

  setUsername(String firstName, String lastName) {
    _firstname = firstName;
    _lastname = lastName;
    _initials = firstName[0] + lastName[0];
  }


  setGoogleSignIn(GoogleSignIn gSI) {
    _googleSignIn = gSI;
    _signInMethod = SignInMethod.Google;
  }

  SignInMethod get signInMethod => _signInMethod;
  String get initials => _initials;
  GoogleSignIn get googleSignIn => _googleSignIn;
  String get bgImage => _bgImage;
  User get user => _user;

  getUID() {
//    print("getting uid");
//    print("user in get uid: $_user");
//    if (_user == null) {
//      print("user is null");
//      return "";
//    }
    if (_user != null) {
      return _user.uid;
    }
  }

  CurrentUser._internal();
}


