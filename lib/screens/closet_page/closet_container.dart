import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:synthetics/screens/closet_page/flippy_card.dart';
import 'package:synthetics/screens/closet_page/outfit_card.dart';
import 'package:synthetics/theme/custom_colours.dart';

class ClosetContainer extends StatelessWidget {
  ClosetContainer(this.mode, {Key key, this.clothingItemObjects})
      : super(key: key);

  final List<ClothingItemObject> clothingItemObjects;
  final ClosetMode mode;
  Set<String> clothingToDonate = Set();

  void donateClothingItem(String id, bool toDonate) {
    print(id);
    print(toDonate);
    if (toDonate) {
      clothingToDonate.add(id);
    } else {
      clothingToDonate.remove(id);
    }
  }

  void donateSelected() {
    print(clothingToDonate);
    // TODO: navigate back to donations and passing back the set of clothes to donate
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
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
                      return FlippyCard(donateClothingItem, clothingItem: item);
                    case (ClosetMode.Normal):
                    default:
                      return ClothingCard(clothingItem: item);
                  }
                }()
            ],
          )),
      mode == ClosetMode.Donate
          ? Positioned(
              bottom: 20.0,
              right: 20.0,
              child: ClipOval(
                child: Material(
                  color: CustomColours.iconGreen(), // button color
                  child: InkWell(
                    splashColor: CustomColours.greenNavy(), // inkwell color
                    child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.done, size: 36, color: Colors.white)),
                    onTap: donateSelected,
                  ),
                ),
              ))
          : Container()
    ]);
  }
}
