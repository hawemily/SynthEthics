import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/routes.dart';
import 'package:synthetics/screens/login/sign_in_method_enum.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';

///
/// Widget for populating the right side drawer on the home page, place for
/// storing additional functionality that are not accessed directly from the
/// navbar or the top bar on the home page
///
class HomeRightDrawer extends StatefulWidget {
  @override
  _HomeRightDrawerState createState() => _HomeRightDrawerState();
}

class _HomeRightDrawerState extends State<HomeRightDrawer> {
  CurrentUser currUser = CurrentUser.getInstance();
  FirebaseAuth auth = FirebaseAuth.instance;

  /// Sign current user out of the application
  void _signOut() {
    if (currUser.signInMethod == SignInMethod.Google) {
      print("signing out from google!");
      currUser.googleSignIn.signOut();
    }
    auth.signOut().then((res) => {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: routes[routeMapping[Screens.Login]]),
              (route) => false)
        });
  }

  /// Delete All user backend data
  void _deleteUser() {
    api_client.post("/deleteUser",
        body: jsonEncode(<String, dynamic>{'uid': currUser.getUID()}));
    auth.currentUser.delete().then((e) {
      print("delete successful from firebase auth frontend!");
    }).catchError((e) {
      print("ERROR WHEN DELETING USER");
      print(e);
    });
  }

  void _showConfirmDeletionDialog(BuildContext context) {
    Widget confirmButton = FlatButton(
        child: Text(
          "OK",
          style: TextStyle(
              color: CustomColours.greenNavy(), fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          _deleteUser();
          _signOut();
        });

    Widget cancelButton = FlatButton(
      child: Text("Cancel",
          style: TextStyle(
              color: CustomColours.negativeRed(), fontWeight: FontWeight.bold)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("We'd love to keep you!"),
      content: Text(
        "Are you sure you want to delete your account? All your data will be lost when this happens.",
        textAlign: TextAlign.justify,
      ),
      actions: [confirmButton, cancelButton],
    );

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
          child: Container(
        color: CustomColours.greenNavy(),
        padding: EdgeInsets.only(top: 200, bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                child: Center(
                    child: Icon(
              Icons.eco,
              size: 80,
              color: CustomColours.iconGreen(),
            ))),
            Container(
                padding: EdgeInsets.only(bottom: 50),
                child: Center(
                    child: Text(
                  "SynthEthics",
                  style:
                      TextStyle(fontSize: 18, color: CustomColours.offWhite()),
                ))),
            _HomeRightDrawerItem(
              // TODO: Remove this and implement functionalities to scanner
              icon: Icons.format_paint,
              text: "Colour Room",
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(routeMapping[Screens.Home]));
                Navigator.pushNamed(context, routeMapping[Screens.ColourRoom]);
              },
            ),
            _HomeRightDrawerItem(
              icon: Icons.exit_to_app,
              text: "Logout",
              onTap: () {
                _signOut();
              },
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _HomeRightDrawerItem(
                    icon: Icons.delete_forever,
                    text: "Delete Account",
                    onTap: () {
                      _showConfirmDeletionDialog(context);
                    },
                    color: CustomColours.offWhite(),
                    backgroundColor: CustomColours.negativeRed(),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}

/// Local widget for representing a drawer item, provides uniformity without
/// limiting user usability
class _HomeRightDrawerItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final Color color;
  final Color backgroundColor;

  _HomeRightDrawerItem({
    this.icon,
    this.text,
    this.onTap,
    Color color,
    Color backgroundColor,
  })  : color = color ?? CustomColours.greenNavy(),
        backgroundColor = backgroundColor ?? CustomColours.offWhite();

  @override
  __HomeRightDrawerItemState createState() => __HomeRightDrawerItemState();
}

class __HomeRightDrawerItemState extends State<_HomeRightDrawerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.backgroundColor),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: widget.backgroundColor,
      ),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: ListTile(
        leading: Icon(
          widget.icon,
          size: 30.0,
          color: widget.color,
        ),
        title: Text(widget.text, style: TextStyle(color: widget.color)),
        onTap: widget.onTap,
      ),
    );
  }
}
