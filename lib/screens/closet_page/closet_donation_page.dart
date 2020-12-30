import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/donation_action_buttons.dart';

import 'action_icons_and_text.dart';
import 'closet_container.dart';
import 'closet_page.dart';

class ClosetDonationPage extends StatelessWidget {
  List<ClothingItemObject> donatedItems;
  final Function setMode;
  final Function action;
  final ClosetMode mode;
  final Function isInDonationList;

  ClosetDonationPage(
      {this.donatedItems,
      this.setMode,
      this.mode,
      this.action,
      this.isInDonationList});

  Widget getActionButtons() {
    List<ActionIconsAndText> normalActionButtons = [
      ActionIconsAndText(
          icon: Icon(Icons.store_mall_directory),
          text: Text("Confirm Donated"),
          onClick: () {
            // TODO: move to a new mode where users can only select clothing in the 'to be donated' tab to indicate that they have already donated the clothing.
            setMode(ClosetMode.Donated);
          }),
      ActionIconsAndText(
          icon: Icon(Icons.restore),
          text: Text("Unmark Donated"),
          onClick: () {
            setMode(ClosetMode.UnDonate);
          })
    ];

    switch (mode) {
      case ClosetMode.Normal:
        return DonationActionButton(floatingActionButtons: normalActionButtons);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClosetContainer(
        mode,
        action: action,
        clothingItemObjects: donatedItems,
        setMode: setMode,
        stagnant: mode == ClosetMode.Donate,
        isFlipped: isInDonationList,
      ),
      getActionButtons()
    ]);
  }
}
