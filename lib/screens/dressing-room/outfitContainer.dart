import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/outfitObject.dart';
import 'package:synthetics/screens/closet_page/outfit_card.dart';

class OutfitContainer extends StatelessWidget {
  OutfitContainer({Key key, this.outfits}) : super(key: key);

  final List<OutfitObject> outfits;

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
              for (var item in this.outfits)
                OutfitCard(outfitClothingList: item.clothingitems)
            ],
          )),
    ]);
  }
}
