import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';

class FlippyCard extends ClothingCard {
  const FlippyCard(this.flipAction, {Key key, clothingItem})
      : super(key: key, clothingItem: clothingItem);

  final Function(String id, bool donated) flipAction;

  @override
  _FlippyCardState createState() => _FlippyCardState();
}

class _FlippyCardState extends ClothingCardState<FlippyCard> {
  @override
  void initState() {
    this.currentClothingItem = widget.clothingItem;
    currClothingItemImage = super.getImage();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      onFlipDone: (status) => widget.flipAction(this.currentClothingItem.id, !status),
      front: super.buildBaseStack(null),
      back: Container(
        child: Text(this.currentClothingItem.data.cF.toString())
      )
    );
  }
}
