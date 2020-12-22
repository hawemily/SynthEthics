import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/outfitListItem.dart';
import 'package:synthetics/screens/closet_page/outfit_card.dart';
import 'package:synthetics/theme/custom_colours.dart';

class OutfitContainer extends StatelessWidget {
  OutfitContainer({Key key, this.outfits}) : super(key: key);

  final List<OutfitListItem> outfits;

  Widget buildOutfitCard(OutfitListItem oF) {
    return Column(children: [
      Container(
          width: 155,
          height: 220,
          color: CustomColours.offWhite(),
          child: FlipCard(
              front: OutfitCard(outfitClothingList: oF.data.clothing),
              back: Card(
                  color: CustomColours.offWhite(),
                  shadowColor: CustomColours.baseBlack(),
                  child: Center(
                    child: SizedBox(
                        width: 70,
                        height: 70,
                        child: RaisedButton(
                            color: CustomColours.negativeRed(),
                            textColor: CustomColours.offWhite(),
                            elevation: 10.0,
                            // splashColor: CustomColours.greenNavy(),
                            highlightColor: CustomColours.accentCopper(),
                            animationDuration: Duration(microseconds: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Wear",
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => print("DoSomething"))),
                  )))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    print("Outfit: ${this.outfits}");
    return Container(
        margin: const EdgeInsets.all(15.0),
        child: new GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            for (var item in this.outfits) buildOutfitCard(item)
            // OutfitCard(outfitClothingList: item.data.clothing)
          ],
        ));
  }
}
