import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

class Auth {
  fbAuth.FirebaseAuth auth;
  static Auth _instance;
  fbAuth.User user;

  static Auth getInstance() {
    if(_instance == null) {
      _instance = Auth._internal();
      _instance.auth = fbAuth.FirebaseAuth.instance;
    }
    return _instance;
  }

  Auth._internal();
}