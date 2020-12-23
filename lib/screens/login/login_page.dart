import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/login/sign_in_button.dart';
import 'package:synthetics/screens/login/sign_in_methods.dart';
import 'package:synthetics/screens/login/sign_in_or_register_with_email.dart';
import 'package:synthetics/theme/custom_colours.dart';

import '../../routes.dart';

class LoginPage extends StatelessWidget {
//  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to Synthetics"),
          centerTitle: true,
          backgroundColor: CustomColours.greenNavy(),
          automaticallyImplyLeading: false,
        ),
        body: Container(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
//                  SignInOrRegisterWithEmailSection(),
              SignInButton(
                img: "lib/assets/google_logo.png",
                name: "Google",
                signInMethod: (BuildContext context) {
                  print("sign in method called!");
                  onGoogleSignIn(context);
                },
              ),
              SignInButton(img: "lib/assets/fb_logo.png", name: "Facebook"),
              SignInButton(
                  img: "lib/assets/email_logo.png",
                  name: "Email",
                  signInScreen: Screens.EmailSignIn)
            ]))));
  }
}
