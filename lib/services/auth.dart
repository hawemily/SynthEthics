import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth auth;
  static Auth _instance;

  static Auth getInstance() {
    if(_instance == null) {
      _instance = Auth._internal();
      _instance.auth = FirebaseAuth.instance;
    }
    return _instance;
  }

  Auth._internal();
}