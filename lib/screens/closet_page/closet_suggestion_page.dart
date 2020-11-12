import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/donation_action_buttons.dart';

import 'action_icons_and_text.dart';
import 'closet_container.dart';
import 'closet_page.dart';

class ClosetSuggestionPage extends StatelessWidget {
  List<ClothingItemObject> suggestedItems;
  final Function setMode;
  final ClosetMode mode;
  final Function donate;
  final Function isUnconfirmedDonation;

  ClosetSuggestionPage(
      {this.suggestedItems,
        this.setMode,
        this.donate,
        this.isUnconfirmedDonation,
        this.mode});

  Widget getActionButtons() {
    List<ActionIconsAndText> normalActionButtons = [
      ActionIconsAndText(
          icon: Icon(Icons.attach_money),
          text: Text("Donate Items"),
          onClick: () {
            setMode(ClosetMode.Donate);
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
      ClosetContainer(
        mode,
        clothingItemObjects: suggestedItems,
        setMode: setMode,
        donate: donate,
        isUnconfirmedDonation: isUnconfirmedDonation,
      ),
      getActionButtons()
    ]);
  }
}