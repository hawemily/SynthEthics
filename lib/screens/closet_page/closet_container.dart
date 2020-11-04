import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:synthetics/screens/closet_page/flippy_card.dart';
import 'package:synthetics/screens/closet_page/outfit_card.dart';

class ClosetContainer extends StatelessWidget {
  const ClosetContainer(this.mode, {Key key, this.clothingItemObjects})
      : super(key: key);

  final List<ClothingItemObject> clothingItemObjects;
  final ClosetMode mode;

  @override
  Widget build(BuildContext context) {
    print(clothingItemObjects[0].data.cF);
    return Container(
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
                    return OutfitCard(
                        outfitClothingList: this.clothingItemObjects);
                  case (ClosetMode.Donate):
                  case (ClosetMode.Normal):
                  default:
                    return FlippyCard((String s, bool f) {print(s); print(f);}, clothingItem: item);
                }
              }()
          ],
        ));
  }
}
