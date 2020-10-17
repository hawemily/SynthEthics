import 'dart:io';

import 'package:flutter/material.dart';
import 'package:synthetics/screens/image_taker_page/image_display_page.dart';
import 'package:synthetics/screens/image_taker_page/image_taker_page.dart';

import '../../routes.dart';

// NavBar class, to be placed on pages as 'bottomNavigationBar'
class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  @override
  Widget build(BuildContext context) {
    final double _iconSize = 30.0;
    final Color _navBarItemColour = Color(0xFF99BF69);
    final String _currentRoute = ModalRoute.of(context).settings.name;

    IconData _firstButtonIcon = Icons.sensor_window;
    var isClosetScreen = _currentRoute == routeMapping[Screens.Closet];
    if (isClosetScreen) {
      _firstButtonIcon = Icons.details;
    }

    return BottomNavigationBar(
        key: Key('navbar'),
        selectedItemColor: _navBarItemColour,
        unselectedItemColor: _navBarItemColour,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: 'wardrobe',
            icon: Icon(_firstButtonIcon, size: _iconSize),
          ),
          BottomNavigationBarItem(
            label: 'add_item',
            icon: Icon(Icons.add_circle_outline, size: _iconSize),
          ),
          BottomNavigationBarItem(
            label: 'donate_item',
            icon: Icon(Icons.place, size: _iconSize),
          )
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              if (isClosetScreen) {
                // We will go to outfits page
                print('GOTO OUTFITS');
              } else {
                // Goto closet page
                print('GOTO CLOSET');
              }
              break;

            case 1:
              ImageTaker.settingModalBottomSheet(context, imageGetterCallback);
              // Currently only goes to display image page, once file storage is
              // designed, we'll save/pass data from there
              break;

            case 2:
              // Go to Donations Page
              print('GOTO DONATIONS');
              break;
          }
        });
  }

  // Callback function used by image taker modal to go to image display page for
  // OCR
  void imageGetterCallback(Future<File> futureFile) {
    futureFile.then((value) {
      if (value != null) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ImageDisplayPage(image: value)));
      }
    });
  }
}
