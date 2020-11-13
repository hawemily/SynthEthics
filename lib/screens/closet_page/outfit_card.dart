import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';

class OutfitCard extends ClothingCard {
  const OutfitCard({Key key, this.outfitClothingList}) : super(key: key);

  final List<ClothingItemObject> outfitClothingList;

  @override
  _OutfitCardState createState() => _OutfitCardState();
}

class _OutfitCardState extends ClothingCardState<OutfitCard> {
  bool clear = false;
  int index = 0;
  ClothingItemObject currentClothingItem;
  Future<File> currClothingItemImage;

  @override
  void initState() {
    this.index = 0;
    this.currentClothingItem = widget.outfitClothingList[this.index];
    currClothingItemImage = getImage();
  }

  Widget getIcon() {
    return GestureDetector(
        onTap: () {
          setState(() {
            // this.clear = true;
            this.clear = !this.clear;
          });
        },
        child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: CustomColours.accentCopper()),
            child: () {
              var icon = null;
              icon = Icons.remove;
              return Icon(icon, color: CustomColours.offWhite(), size: 10.0);
            }()));
  }

  List<Widget> getLeftRightControls() {
    return <Widget>[
      Positioned(
          top: 75.0,
          left: 15.0,
          child: GestureDetector(
              onTap: () {
                if (index > 0) {
                  setState(() {
                    this.currentClothingItem =
                        widget.outfitClothingList[this.index - 1];
                    this.currClothingItemImage = getImage();
                    this.index = this.index - 1;
                  });
                }
              },
              child: this.index == 0
                  ? Container()
                  : Icon(Icons.arrow_back_ios,
                      color: CustomColours.greenNavy(), size: 20.0))),
      Positioned(
          top: 75.0,
          right: 10.0,
          child: GestureDetector(
              onTap: () {
                if (index < widget.outfitClothingList.length - 1) {
                  setState(() {
                    this.currentClothingItem =
                        widget.outfitClothingList[this.index + 1];
                    this.currClothingItemImage = getImage();
                    this.index = this.index + 1;
                  });
                }
              },
              child: this.index == widget.outfitClothingList.length - 1
                  ? Container()
                  : Icon(Icons.arrow_forward_ios,
                      color: CustomColours.greenNavy(), size: 20.0)))
    ];
  }

  @override
  Widget buildImage() {
    return clear
        ? Align(
            alignment: Alignment.center,
            child: Icon(Icons.block, color: CustomColours.accentCopper()))
        : super.buildImage();
  }

  // void tapAction() {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               ClothingItem(clothingItem: this.currentClothingItem)));
  // }

  @override
  Widget build(BuildContext context) {
    // Stack stack = this.buildBaseStack(this.tapAction, clear: this.clear);
    Stack stack = this.buildBaseStack(() => print("Get item dashboard page"),
        clear: this.clear);
    stack.children.add(Positioned(top: 0.0, right: 0.0, child: getIcon()));
    // if (!clear) {
    stack.children.addAll(getLeftRightControls());
    // }
    return stack;
  }
}
