import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';

class ClosetContainer extends StatelessWidget {
  const ClosetContainer({Key key, this.clothingItemObjects, this.isCloset})
      : super(key: key);

  final List<ClothingItemObject> clothingItemObjects;
  final bool isCloset;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5.0),
        child: new GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            for (var item in this.clothingItemObjects)
              // ClothingCard(clothingId: id, display: ClothingCardDisplay.Closet)
              this.isCloset
                  ? ClothingCard(
                      clothingItem: item, display: ClothingCardDisplay.ClosetSelect)
                  : ClothingCard(
                      clothingItem: item, display: ClothingCardDisplay.Closet)
          ],
        ));
  }
}
