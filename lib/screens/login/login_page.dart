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
        body: Center(
            child: ListView(shrinkWrap: true, children: <Widget>[
          Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                Image(
                    image: AssetImage("lib/assets/leaf.jpg"),
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 4),
                Text("Synthetics",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColours.greenNavy(),
                        fontSize: MediaQuery.of(context).size.width / 13,)),
              ])),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SignInButton(
                  img: "lib/assets/google_logo.png",
                  name: "Google",
                  signInMethod: (BuildContext context) {
                    print("sign in method called!");
                    onGoogleSignIn(context);
                  },
                ),
                SignInButton(
                    img: "lib/assets/email_logo.png",
                    name: "Email",
                    signInScreen: Screens.EmailSignIn),
              ])
        ])));
  }
}
