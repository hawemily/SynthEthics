import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';

class SelectCard extends ClothingCard {
  const SelectCard(this.selectAction, {Key key, clothingItem})
      : super(key: key, clothingItem: clothingItem);

  final Function(String id, bool selected) selectAction;

  @override
  _SelectCardState createState() => _SelectCardState();
}

class _SelectCardState extends ClothingCardState<SelectCard> {
  bool selected;

  @override
  void initState() {
    this.currentClothingItem = widget.clothingItem;
    currClothingItemImage = super.getImage();
    selected = false;
  }

  void select() {
    widget.selectAction(widget.clothingItem.id, !this.selected);
    setState(() {
      this.selected = !this.selected;
    });
  }

  Widget getIcon() {
    return Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: CustomColours.accentCopper()),
            child: () {
              return Icon(Icons.done,
                  color: CustomColours.offWhite(), size: 10.0);
            }());
  }

  @override
  Widget build(BuildContext context) {
    Stack stack = this.buildBaseStack(select);
    if (selected) {
      stack.children.add(Positioned(top: 0.0, right: 0.0, child: getIcon()));
    }
    return stack;
  }
}
