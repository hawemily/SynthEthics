import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/responseObjects/outfitListItem.dart';
import 'package:synthetics/screens/closet_page/outfit_card.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';

class OutfitContainer extends StatelessWidget {
  OutfitContainer({Key key, this.outfits}) : super(key: key);

  final List<OutfitListItem> outfits;
  CurrentUser user = CurrentUser.getInstance();

  Future<void> updateAllItems(OutfitListItem oF) async {
    List<ClothingItemObject> clothing = oF.data.clothing;

    List<String> clothingIds = new List(clothing.length);
    List<double> timesWorns = new List(clothing.length);
    List<int> carmaGains = new List(clothing.length);

    int i = 0;
    for (ClothingItemObject c in clothing) {
      clothingIds[i] = c.id;
      timesWorns[i] = c.data.currentTimesWorn + 1;
      carmaGains[i] = (c.data.cF / c.data.maxNoOfTimesToBeWorn).round();
      i++;
    }


    await api_client
        .post("/updateOutfit",
            body: jsonEncode(<String, dynamic>{
              'uid': user.getUID(),
              'clothingIds': clothingIds,
              'timesWorns': timesWorns,
              'lastWorn': DateTime.now().toString(),
              'carmaGains': carmaGains,
              'outfitId': oF.id
            }))
        .then((e) {
      print(e.statusCode);
      print(e.body);
    });

  }

  Widget buildOutfitCard(OutfitListItem oF) {
    return Column(children: [
      Container(
          width: 155,
          height: 220,
          color: CustomColours.offWhite(),
          child: FlipCard(
              front: OutfitCard(outfitClothingList: oF.data.clothing),
              back: Card(
                  elevation: 5,
                  color: CustomColours.greenNavy(),
                  shadowColor: CustomColours.baseBlack(),
                  child: Center(
                    child: SizedBox(
                        width: 70,
                        height: 70,
                        child: FlatButton(
                            color: CustomColours.greenNavy(),
                            textColor: CustomColours.offWhite(),
                            // splashColor: CustomColours.greenNavy(),
                            highlightColor: CustomColours.iconGreen(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Wear",
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => updateAllItems(oF))),
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
