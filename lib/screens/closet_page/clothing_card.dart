import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';

enum ClothingCardDisplay { Closet, DressingRoom, ClosetSelect }

class ClothingCard extends StatelessWidget {
  const ClothingCard({Key key, this.clothingId, this.display})
      : super(key: key);

  final int clothingId;
  final ClothingCardDisplay display;

  Widget getIcon() {
    return GestureDetector(
        onTap: () {
          print("do something to clothing " + clothingId.toString());
        },
        child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.blueGrey),
            child: () {
              var icon = null;
              if (display == ClothingCardDisplay.DressingRoom) {
                icon = Icons.remove;
              } else {
                icon = Icons.done;
              }
              return Icon(icon, color: Colors.white, size: 10.0);
            }()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: (() {
      var base = <Widget>[
        Card(
            color: Colors.blue,
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
                            child: Text(
                                "Clothing Image " + this.clothingId.toString()),
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
      }
      return base;
    }()));
  }
}
