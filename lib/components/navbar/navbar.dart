import 'dart:io';

import 'package:flutter/material.dart';
import 'package:synthetics/screens/image_taker_page/image_display_page.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:synthetics/services/image_taker/image_taker.dart';
import 'package:synthetics/theme/custom_colours.dart';

import '../../routes.dart';

// NavBar class, to be placed on pages as 'bottomNavigationBar'
class NavBar extends StatefulWidget {
  final selected;

  NavBar({this.selected});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  void _clearStackAndPush(Screens screen) {
    if (ModalRoute.of(context).settings.name != routeMapping[screen]) {
      Navigator.popUntil(
          context, ModalRoute.withName(routeMapping[Screens.Home]));
      if (screen != Screens.Home) {
        Navigator.pushNamed(context, routeMapping[screen]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _iconSize = 30.0;
    final Color _navBarItemColour = CustomColours.iconGreen();

    return BottomNavigationBar(
        key: Key('navbar'),
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.selected,
        selectedItemColor: _navBarItemColour,
        unselectedItemColor: CustomColours.greenNavy(),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              label: 'home', icon: Icon(Icons.home, size: _iconSize)),
          BottomNavigationBarItem(
            label: 'wardrobe',
            icon: Icon(Icons.sensor_window, size: _iconSize),
          ),
          BottomNavigationBarItem(
            label: 'add_item',
            icon: Icon(Icons.add_circle_outline, size: _iconSize),
          ),
          BottomNavigationBarItem(
              label: 'outfits', icon: Icon(Icons.details, size: _iconSize)),
          BottomNavigationBarItem(
            label: 'donate_item',
            icon: Icon(Icons.place, size: _iconSize),
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              _clearStackAndPush(Screens.Home);
              break;

            case 1:
              _clearStackAndPush(Screens.Closet);
              break;

            case 2:
              // Produces a modal for taking a picture, then goes to image
              // display page via a callback function given to the image taker
              ImageTaker.settingModalBottomSheet(context, imageGetterCallback);
              break;

            case 3:
              // TODO: Add outfits page navigation here
              _clearStackAndPush(Screens.DressingRoom);
              break;

            case 4:
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
