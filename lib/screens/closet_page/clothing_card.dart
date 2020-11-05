import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';

class ClothingCard extends StatefulWidget {
  const ClothingCard({Key key, this.clothingItem}) : super(key: key);

  final ClothingItemObject clothingItem;

  @override
  ClothingCardState createState() => ClothingCardState();
}

class ClothingCardState<T extends ClothingCard> extends State<T> {
  ClothingItemObject currentClothingItem;
  Future<File> currClothingItemImage;

  @override
  void initState() {
    currentClothingItem = widget.clothingItem;
    currClothingItemImage = getImage();
  }

  Future<File> getImage() {
    return ImageManager.getInstance()
        .loadPictureFromDevice(this.currentClothingItem.id);
  }

  void tapAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ClothingItem(clothingItem: this.currentClothingItem)));
  }

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

  Widget buildBaseStack(on_tap, {clear=false}) {
    return Stack(children: [
      Card(
          color: CustomColours.offWhite(),
          margin: EdgeInsets.all(5.0),
          child: InkWell(
              onTap: on_tap,
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Stack(children: [
                    buildImage(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: clear ? Container() : EcoBar(
                            current:
                                this.currentClothingItem.data.currentTimesWorn,
                            max: this
                                .currentClothingItem
                                .data
                                .maxNoOfTimesToBeWorn)),
                  ]))))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return this.buildBaseStack(this.tapAction);
  }
}
