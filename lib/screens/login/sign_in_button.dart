import 'package:flutter/material.dart';
import 'package:synthetics/theme/custom_colours.dart';

import '../../routes.dart';

class SignInButton extends StatelessWidget {
  SignInButton({this.img, this.signInScreen, this.name, this.signInMethod});

  final String img;
  final Screens signInScreen;
  final Function signInMethod;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: OutlineButton(
            splashColor: Colors.grey,
            onPressed: () {
              if (signInScreen != null) {
                Navigator.pushNamed(
                    context, routeMapping[signInScreen]);
              } else {
                signInMethod(context);
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            borderSide: BorderSide(color: Colors.grey),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image(image: AssetImage(img), height: 35.0),
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('Sign in with ' + name,
                            style: TextStyle(
                                fontSize: 20,
                                color: CustomColours.greenNavy())))
                  ],
                ))));
  }
}
