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
  const OutfitCard({Key key, this.outfitClothingList, this.resetDressingRoom})
      : super(key: key);

  final Function resetDressingRoom;
  final List<ClothingItemObject> outfitClothingList;

  @override
  _OutfitCardState createState() => _OutfitCardState();
}

class _OutfitCardState extends ClothingCardState<OutfitCard> {
  int index = 0;
  ClothingItemObject currentClothingItem;
  Future<File> currClothingItemImage;

  @override
  void initState() {
    this.index = 0;
    this.currentClothingItem = widget.outfitClothingList[this.index];
    this.currClothingItemImage = getImage();
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
    return FutureBuilder<File>(
        future: this.currClothingItemImage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.file(snapshot.data);
          } else if (snapshot.data == null) {
            return Text("No image from file");
          }
          return LinearProgressIndicator();
        });
  }

  void getTimesWornDressingRoom() {
    this.returnTimesWorn();
    widget.resetDressingRoom();
  }

  void tapAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClothingItem(
                  clothingItem: widget.outfitClothingList[this.index],
                  getTimesWorn: getTimesWornDressingRoom,
                )));
  }

  @override
  Widget build(BuildContext context) {
    Stack stack = this.buildBaseStack(this.tapAction);
    stack.children.addAll(getLeftRightControls());
    return stack;
  }
}
