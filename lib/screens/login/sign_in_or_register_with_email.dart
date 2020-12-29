import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/requestObjects/new_user_request.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/routes.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInOrRegisterWithEmailSection extends StatefulWidget {
  @override
  _SignInOrRegisterWithEmailSectionState createState() =>
      _SignInOrRegisterWithEmailSectionState();
}

class _SignInOrRegisterWithEmailSectionState
    extends State<SignInOrRegisterWithEmailSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _registerSuccess;
  bool _loginSuccess;
  String _email;
  String _errorText;
  bool _isSignUp;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _isSignUp = false;
    super.initState();
  }

  void _register() async {
    User user;

    try {
      user = (await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user;
    } on FirebaseException catch (e) {
      setState(() {
        _errorText = e.code;
      });
      print(e);
    } catch (e) {
      print("Non firebase auth error related $e");
    }

    if (user != null) {
      setState(() {
        _registerSuccess = true;
        _email = user.email;
      });

      NewUserRequest req = new NewUserRequest(user.uid, _usernameController.text);
      api_client.post("/addUser", body: jsonEncode(req));

      CurrentUser currUser = CurrentUser.getInstance();
      currUser.setUser(user);

      Navigator.pushNamed(context, routeMapping[Screens.Home]);
    } else {
      setState(() {
        _registerSuccess = false;
      });

      print("succ: $_registerSuccess");
    }
  }

  void _signIn() async {
    User user;

    try {
      user = (await _auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.code;
      });
      print(e);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Error"),
                content: Text(e.message),
                actions: [
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: Navigator.of(context).pop,
                  )
                ]);
          });
    } catch (e) {
      print("Non firebase auth error related $e");
    }

    if (user != null) {
      setState(() {
        _loginSuccess = true;
        _email = _emailController.text;
      });

      print("got user!!");
      print("user.uid, ${user.uid}");

      CurrentUser currUser = CurrentUser.getInstance();
      currUser.setUser(user);

      // TODO: Remove User init code once deployed
      api_client.post("/initUsers", body: jsonEncode({"uid": user.uid}));

      Navigator.pushNamed(context, routeMapping[Screens.Home]);
    } else {
      setState(() {
        _loginSuccess = false;
      });
    }
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  bool _notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.all(50.0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    children: <Widget>[
                  _isSignUp
                      ? TextFormField(
                          controller: _usernameController,
                          decoration:
                              const InputDecoration(labelText: "Username"),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please enter your username";
                            }
                            return null;
                          })
                      : null,
                  TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please enter your email address";
                        }
                        return null;
                      }),
                  TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      }),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            (_isSignUp
                                ? null
                                : RaisedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _signIn();
                                      }
                                    },
                                    child: Text("Log In"))),
                            RaisedButton(
                                onPressed: () async {
                                  if (!_isSignUp) {
                                    setState(() {
                                      _isSignUp = !_isSignUp;
                                    });
                                  } else {
                                    if (_formKey.currentState.validate()) {
                                      _register();
                                    }
                                  }
                                },
                                child: Text("Sign Up"))
                          ].where(_notNull).toList())),
                  Container(
                      alignment: Alignment.center,
                      child: Text(_registerSuccess == null
                          ? _loginSuccess == null
                              ? ''
                              : (_loginSuccess
                                  ? "User logging in!"
                                  : "Username does not exist! Please sign up instead.")
                          : (_registerSuccess
                              ? "Successfully registered " + _email
                              : "Failed to register")))
                ].where(_notNull).toList()))));
  }
}

class SignInOrRegisterWithEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to Synthetics"),
          centerTitle: true,
          backgroundColor: CustomColours.greenNavy(),
        ),
        body: SignInOrRegisterWithEmailSection());
  }
}
