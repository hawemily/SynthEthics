import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/responseObjects/getClosetResponse.dart';
import 'package:synthetics/screens/closet_page/donation_action_buttons.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/services/api_client.dart';

import 'action_icons_and_text.dart';
import 'closet_container.dart';
import 'closet_page.dart';

class ClosetDonationPage extends StatelessWidget {
  List<ClothingItemObject> donatedItems;
  final Function setMode;
  final ClosetMode mode;

  ClosetDonationPage({this.donatedItems, this.setMode, this.mode});

  @override
  Widget build(BuildContext context) {
    List<ActionIconsAndText> actionButtons = [
      ActionIconsAndText(icon: Icon(Icons.attach_money),
          text: Text("Donate Items"),
          onClick: () {
            setMode(ClosetMode.Donate);
          }),
      ActionIconsAndText(
          icon: Icon(Icons.check), text: Text("Mark Donated"), onClick: () {
       setMode(ClosetMode.Select);
      })
    ];

    return Stack(children: [
      ClosetContainer(
        mode,
        clothingItemObjects: donatedItems,
        setMode: setMode,
      ),
      DonationActionButton(floatingActionButtons: actionButtons),
//      Positioned(
//          left: MediaQuery.of(context).size.width / 2 + 30,
//          top: MediaQuery.of(context).size.height / 2 + 50,
//          child: DonationActionButton(floatingActionButtons: actionButtons),
//          ),
    ]
    );
  }
}

