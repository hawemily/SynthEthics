import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/login/sign_in_or_register_with_email.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login Page"),
        automaticallyImplyLeading: false,),
        body: Column(children: <Widget>[
          SignInOrRegisterWithEmailSection(auth:_auth, isSignIn: false,)
        ]));
  }
}
