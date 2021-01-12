import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:synthetics/requestObjects/new_user_request.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/routes.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void onGoogleSignIn(BuildContext context, Function progressToggle) async {
  CurrentUser currUser = CurrentUser.getInstance();
  currUser.setGoogleSignIn(_googleSignIn);
  User user = await _handleSignIn(progressToggle);
  currUser.setUser(user);

  Navigator.pushNamed(context, routeMapping[Screens.Home]);
}

Future<User> _handleSignIn(Function progressToggle) async {
  User user;
  bool userSignedIn = await _googleSignIn.isSignedIn();

  if (userSignedIn) {
    print("usersignedin!");
    user = _auth.currentUser;
    _googleSignIn.signOut();
    print('user uid: ${user.uid}');
  } else {
    print("signing in with Google!");
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print("signing in with Google! line 29");

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    print("signing in with Google! line 22");

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    progressToggle();
    print("signing in with Google! line 29");
    user = (await _auth.signInWithCredential(credential)).user;
    print('user uid: ${user.uid}');
    print('user: $user');

    NewUserRequest req = new NewUserRequest(user.uid, user.displayName);
    api_client.post("/addUser", body: jsonEncode(req));

    await GoogleSignIn().isSignedIn();
  }

  return user;
}
