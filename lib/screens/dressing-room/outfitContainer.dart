import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/outfitListItem.dart';
import 'package:synthetics/screens/closet_page/outfit_card.dart';
import 'package:synthetics/theme/custom_colours.dart';

class OutfitContainer extends StatelessWidget {
  OutfitContainer({Key key, this.outfits}) : super(key: key);

  final List<OutfitListItem> outfits;

  Widget combine(OutfitListItem oF) {
    return Column(children: [
      SizedBox(
          width: 150,
          height: 200,
          child: OutfitCard(outfitClothingList: oF.data.clothing)),
      Padding(
        padding: EdgeInsets.only(bottom: 5),
      ),
      SizedBox(
          width: 65,
          height: 40,
          child: RaisedButton(
              color: CustomColours.negativeRed(),
              textColor: CustomColours.offWhite(),
              elevation: 5.0,
              // splashColor: CustomColours.greenNavy(),
              highlightColor: CustomColours.accentCopper(),
              animationDuration: Duration(microseconds: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text("Wear"),
              onPressed: () => print("DoSomething"))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    print("Outfit: ${this.outfits}");
    return Container(
        margin: const EdgeInsets.all(15.0),
        child: new GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            for (var item in this.outfits) combine(item)
            // OutfitCard(outfitClothingList: item.data.clothing)
          ],
        ));
  }
}
