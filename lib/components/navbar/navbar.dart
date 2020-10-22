import 'dart:io';

import 'package:flutter/material.dart';
import 'package:synthetics/screens/image_taker_page/image_display_page.dart';
import 'package:synthetics/screens/image_taker_page/image_taker_page.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:synthetics/theme/custom_colours.dart';

import '../../routes.dart';

// NavBar class, to be placed on pages as 'bottomNavigationBar'
class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  void _clearStackAndPush(Screens screen) {
    if (ModalRoute.of(context).settings.name != routeMapping[screen]) {
      Navigator.popUntil(
          context,
          ModalRoute.withName(routeMapping[Screens.Home])
      );
      Navigator.pushNamed(context, routeMapping[screen]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _iconSize = 30.0;
    final Color _navBarItemColour = CustomColours.iconGreen();
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
                // TODO: Implement outfits page
                print('GOTO OUTFITS');
              } else {
                // Goto closet page
                // TODO: Remove this variable from the navbar, should be fetched in initState of its target page
                final categories = [
                  "tops",
                  "bottoms",
                  "skirts",
                  "dresses",
                  "outerwear",
                  "headgear"
                ];
                // TODO: Replace this with a _clearStackAndPush, add a corr. route in routes
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Closet(
                              categories: categories,
                            )));
              }
              break;

            case 1:
              // Produces a modal for taking a picture, then goes to image
              // display page via a callback function given to the image taker
              ImageTaker.settingModalBottomSheet(context, imageGetterCallback);
              break;

            case 2:
              // Go to Donations Page
              _clearStackAndPush(Screens.Donation);
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
            MaterialPageRoute(
                builder: (context) => ImageDisplayPage(image: value)));
      }
    });
  }
}
