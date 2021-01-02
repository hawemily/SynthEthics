import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/routes.dart';
import 'package:synthetics/screens/login/sign_in_method_enum.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeRightDrawer extends StatefulWidget {
  @override
  _HomeRightDrawerState createState() => _HomeRightDrawerState();
}

class _HomeRightDrawerState extends State<HomeRightDrawer> {
  CurrentUser currUser = CurrentUser.getInstance();
  FirebaseAuth auth = FirebaseAuth.instance;

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

  void _deleteUser() {
    api_client.post("/deleteUser",
        body: jsonEncode(
            <String, dynamic>{'uid': currUser.getUID()}));
    auth.currentUser.delete().then((e){
      print("delete successful from firebase auth frontend!");
    }).catchError((e) {
      print("ERROR WHEN DELETING USER");
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
          child: Container(
        color: CustomColours.greenNavy(),
        padding: EdgeInsets.only(top: 100),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                child: Center(
                    child: Icon(
              Icons.eco,
              size: 50,
              color: CustomColours.offWhite(),
            ))),
            Container(
                padding: EdgeInsets.only(bottom: 50),
                child: Center(
                    child: Text(
                  "Synthethics",
                  style: TextStyle(color: CustomColours.offWhite()),
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
              icon: Icons.accessibility,
              text: "Accessibility",
              onTap: () {
                print("Accessibility");
              },
            ),
            _HomeRightDrawerItem(
              icon: Icons.mobile_screen_share,
              text: "Data Transfer",
              onTap: () {
                print("Transfer Data");
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
                      _deleteUser();
                      _signOut();
                    },
                  )),
            ),
          ],
        ),
      )),
    );
  }
}

class _HomeRightDrawerItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  _HomeRightDrawerItem({this.icon, this.text, this.onTap});

  @override
  __HomeRightDrawerItemState createState() => __HomeRightDrawerItemState();
}

class __HomeRightDrawerItemState extends State<_HomeRightDrawerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomColours.offWhite()),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: CustomColours.offWhite(),
      ),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: ListTile(
        leading: Icon(
          widget.icon,
          size: 30.0,
          color: CustomColours.greenNavy(),
        ),
        title: Text(widget.text,
            style: TextStyle(color: CustomColours.greenNavy())),
        onTap: widget.onTap,
      ),
    );
  }
}
