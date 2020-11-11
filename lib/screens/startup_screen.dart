import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synthetics/routes.dart';
import 'package:synthetics/screens/login/login_page.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';

import 'home_page/home_page.dart';

class StartupScreen extends StatelessWidget {
  final User result = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {

    if (result != null) {
      CurrentUser user = CurrentUser.getInstance();
      user.setUID(result.uid);
    }
    return new SplashScreen(
      navigateAfterSeconds: result != null ? routeMapping[Screens.Home] : routeMapping[Screens.Login],
      seconds: 5,
      title: new Text(
        'Welcome to Synthethics!',
        style: new TextStyle(fontWeight: FontWeight.w300, fontSize: 25.0, color: CustomColours.offWhite()),
      ),
      backgroundColor: CustomColours.greenNavy(),
      loaderColor: Colors.black,
    );
  }
}
