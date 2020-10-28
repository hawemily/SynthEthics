import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/theme/custom_colours.dart';

enum ClothingCardDisplay { Closet, Outfit, ClosetSelect }

class ClothingCard extends StatefulWidget {
  const ClothingCard(
      {Key key, this.clothingId, this.clothingList, this.display})
      : super(key: key);

  final int clothingId;
  final List<int> clothingList;
  final ClothingCardDisplay display;

  @override
  _ClothingCardState createState() {
    if (clothingList != null) {
      return _ClothingCardState(display, clothingList: clothingList);
    } else if (clothingId != null) {
      return _ClothingCardState(display, clothingId: clothingId);
    } else {
      return _ClothingCardState(display);
    }
  }
}

class _ClothingCardState extends State<ClothingCard> {
  _ClothingCardState(this.display, {this.clothingId, this.clothingList}) {
    if (this.clothingList != null) {
      this.index = 0;
      this.currentClothingId = this.clothingList[this.index];
    } else if (this.clothingId != null) {
      this.currentClothingId = this.clothingId;
    } else {
      this.currentClothingId = -1;
    }
  }

  bool clear = false;
  int index = -1;
  int currentClothingId;
  final int clothingId;
  final List<int> clothingList;
  final ClothingCardDisplay display;

  Widget getIcon() {
    return GestureDetector(
        onTap: () {
          if (display == ClothingCardDisplay.Outfit) {
            setState(() {
              this.clear = true;
            });
          } else if (display == ClothingCardDisplay.ClosetSelect) {
            print("select");
          }
        },
        child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: CustomColours.negativeRed()),
            child: () {
              var icon = null;
              if (display == ClothingCardDisplay.Outfit) {
                icon = Icons.remove;
              } else {
                icon = Icons.done;
              }
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
                    this.currentClothingId = this.clothingList[this.index - 1];
                    this.index = this.index - 1;
                  });
                }
              },
              child: Icon(Icons.arrow_back_ios,
                  color: this.index == 0 ? Colors.grey : CustomColours.offWhite(),
                  size: 20.0))),
      Positioned(
          top: 75.0,
          right: 10.0,
          child: GestureDetector(
              onTap: () {
                if (index < clothingList.length - 1) {
                  setState(() {
                    this.currentClothingId = this.clothingList[this.index + 1];
                    this.index = this.index + 1;
                  });
                }
              },
              child: Icon(Icons.arrow_forward_ios,
                  color: this.index == this.clothingList.length - 1
                      ? Colors.grey
                      : CustomColours.offWhite(),
                  size: 20.0)))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: (() {
      var base = <Widget>[
        Card(
            color: CustomColours.offWhite(),
            margin: EdgeInsets.all(5.0),
            child: InkWell(
                onTap: () => {print("object is being tapped")},
                child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Stack(
                        children: (() {
                      var cardChildren = <Widget>[
                        Ink(
                          // to be replaced with image
                          color: Colors.grey,
                          width: 147,
                          height: 147,
                          child: Container(
                            child: Text("Clothing Image " +
                                this.currentClothingId.toString()),
                            alignment: Alignment.center,
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: EcoBar(current: 20, max: 20)),
                      ];
                      return cardChildren;
                    }())))))
      ];

      if (display != ClothingCardDisplay.Closet) {
        base.add(Positioned(top: 0.0, right: 0.0, child: getIcon()));
        if (display == ClothingCardDisplay.Outfit) {
          base.addAll(getLeftRightControls());
        }
      }
      return base;
    }()));
  }
}
