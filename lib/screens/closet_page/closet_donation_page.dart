import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/donation_action_buttons.dart';

import 'action_icons_and_text.dart';
import 'closet_container.dart';
import 'closet_page.dart';

class ClosetDonationPage extends StatelessWidget {
  List<ClothingItemObject> donatedItems;
  final Function setMode;
  final ClosetMode mode;

  ClosetDonationPage(
      {this.donatedItems,
        this.setMode,
        this.mode});

  Widget getActionButtons() {
    List<ActionIconsAndText> normalActionButtons = [
      ActionIconsAndText(
          icon: Icon(Icons.attach_money),
          text: Text("Donate Items"),
          onClick: () {
            setMode(ClosetMode.Donate);
          }),
      ActionIconsAndText(
          icon: Icon(Icons.check),
          text: Text("Mark Donated"),
          onClick: () {
            setMode(ClosetMode.Select);
          })
    ];

    List<ActionIconsAndText> donateActionButtons = [
      ActionIconsAndText(
          icon: Icon(Icons.check),
          text: Text("Done"),
          onClick: () {
            setMode(ClosetMode.Normal);
          })
    ];

    switch (mode) {
      case ClosetMode.Normal:
        return DonationActionButton(floatingActionButtons: normalActionButtons);
      case ClosetMode.Donate:
        return DonationActionButton(floatingActionButtons: donateActionButtons);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClosetContainer(mode,
          clothingItemObjects: donatedItems,
          setMode: setMode,
          stagnant: true),
      getActionButtons()
    ]);
  }
}