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
  SelectCard(this.selectAction,
      {Key key, clothingItem, bool this.markForDonation = false})
      : super(key: key, clothingItem: clothingItem);

  final Function(String id, bool selected) selectAction;
  bool markForDonation;

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
          return Icon(Icons.done, color: CustomColours.offWhite(), size: 10.0);
        }());
  }

  Widget buildMarkForDonationStack() {
    double donateGain = this.currentClothingItem.data.cF *
        (1 -
            this.currentClothingItem.data.currentTimesWorn /
                this.currentClothingItem.data.maxNoOfTimesToBeWorn);

    return Stack(children: [
      Card(
          color: CustomColours.offWhite(),
          margin: EdgeInsets.all(5.0),
          child: InkWell(
              onTap: select,
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Stack(children: [
                    buildImage(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: EcoBar(
                            current:
                                this.currentClothingItem.data.currentTimesWorn,
                            max: this
                                .currentClothingItem
                                .data
                                .maxNoOfTimesToBeWorn)),
                    Opacity(
                        opacity: 0.8, child: Container(color: Colors.white)),
                    Column(children: [
                      Expanded(
                          flex: 5,
                          child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Icon(Icons.eco,
                                      color: CustomColours.accentCopper())))),
                      Expanded(
                          flex: 5,
                          child: Text(
                              (donateGain.round()).toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColours.accentCopper())))
                    ]),
                  ]))))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Stack stack = widget.markForDonation
        ? this.buildMarkForDonationStack()
        : super.buildBaseStack(select);
    if (selected) {
      stack.children.add(Positioned(top: 0.0, right: 0.0, child: getIcon()));
    }

    return stack;
  }
}
