import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/login/sign_in_button.dart';
import 'package:synthetics/screens/login/sign_in_methods.dart';
import 'package:synthetics/screens/login/sign_in_or_register_with_email.dart';
import 'package:synthetics/theme/custom_colours.dart';

import '../../routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoggingIn = false;

  void toggleIsLoggingIn() {
    setState(() {
      _isLoggingIn = !_isLoggingIn;
    });
  }

  Widget loadingOverlay() {
    return _isLoggingIn ? new Container(color: Colors.white,
        child: Center(child: CircularProgressIndicator())) : null;;
  }

  bool notNull(Object o) => o != null;

  Widget _LoginPage() {
    return Center(
        child: Stack(children: <Widget>[
          ListView(shrinkWrap: true, children: <Widget>[
            Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(16.0),
                child: Column(children: <Widget>[
                  Image(
                      image: AssetImage("lib/assets/leaf.jpg"),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 3,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 4),
                  Text("SynthEthics",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColours.greenNavy(),
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .width / 13,
                      )),
                ])),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SignInButton(
                    img: "lib/assets/google_logo.png",
                    name: "Google",
                    signInMethod: (BuildContext context) {
                      print("sign in method called!");
                      onGoogleSignIn(context, toggleIsLoggingIn);
                    },
                  ),
                  SignInButton(
                      img: "lib/assets/email_logo.png",
                      name: "Email",
                      signInScreen: Screens.EmailSignIn),
                ])
          ]),
          loadingOverlay(),
        ].where(notNull).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to SynthEthics"),
          centerTitle: true,
          backgroundColor: CustomColours.greenNavy(),
          automaticallyImplyLeading: false,
        ),
        body: _LoginPage());
  }
}
