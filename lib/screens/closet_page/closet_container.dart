import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/requestObjects/donated_item_metadata.dart';
import 'package:synthetics/requestObjects/items_to_donate_request.dart';
import 'package:synthetics/responseObjects/clothingTypeObject.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:synthetics/screens/closet_page/donation_action_buttons.dart';
import 'package:synthetics/screens/closet_page/flippy_card.dart';
import 'package:synthetics/screens/closet_page/outfit_card.dart';
import 'package:synthetics/screens/closet_page/select_card.dart';
import 'package:synthetics/services/api_client.dart';
import 'action_icons_and_text.dart';

class ClosetContainer extends StatelessWidget {
  ClosetContainer(this.mode,
      {Key key,
      this.clothingItemObjects,
      this.setMode,
      this.action,
      this.isUnconfirmedDonation,
      this.stagnant = false})
      : super(key: key);

  final List<ClothingItemObject> clothingItemObjects;
  final ClosetMode mode;
  final Function setMode;
  final Function action;
  final Function isUnconfirmedDonation;
  final bool stagnant;

  @override
  Widget build(BuildContext context) {

    return Stack(children: [
      Container(
          margin: const EdgeInsets.all(5.0),
          child: new GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              for (var item in this.clothingItemObjects)
                () {
                  switch (this.mode) {
                    case (ClosetMode.Select):
                      return ClothingCard(
                        clothingItem: item,
                        isOutfit: true,
                        selectItemForOutfit: donate,
                      );
                    case (ClosetMode.Donate):
                      return stagnant
                          ? ClothingCard(clothingItem: item)
                          : FlippyCard(action, isUnconfirmedDonation(item.id),
                              clothingItem: item);
                    case (ClosetMode.UnDonate):
                      return SelectCard(action, clothingItem: item);
                    case (ClosetMode.Normal):
                    default:
                      return ClothingCard(clothingItem: item);
                  }
                }()
            ],
          )),
    ]);
  }
}
