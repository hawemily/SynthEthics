import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/outfitListItem.dart';
import 'package:synthetics/screens/closet_page/outfit_card.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';

class OutfitContainer extends StatefulWidget {
  OutfitContainer(
      {Key key, this.outfits, this.updateFunction, this.resetDressingRoom})
      : super(key: key);

  final List<OutfitListItem> outfits;
  final Function updateFunction;
  final Function resetDressingRoom;

  @override
  _OutfitContainerState createState() => _OutfitContainerState();
}

class _OutfitContainerState extends State<OutfitContainer> {
  final CurrentUser user = CurrentUser.getInstance();
  List<GlobalKey<FlipCardState>> keys = [];

  Future<void> deleteOutfit(String id) async {
    print("Delete $id");
    await api_client
        .post("/deleteOutfit",
            body: jsonEncode(<String, dynamic>{
              'uid': user.getUID(),
              'oid': id,
            }))
        .then((e) {
      print(e.statusCode);
      print(e.body);
    });
    setState(() {
      widget.resetDressingRoom();
    });
  }

  void wearOutfit(OutfitListItem oF) {
    setState(() {
      widget.updateFunction(oF);
      widget.resetDressingRoom();
    });
  }

  int getTotalCarmaGain(OutfitListItem oF) {
    double total = 0;
    oF.data.clothing.forEach((item) {
      total += (item.data.cF / item.data.maxNoOfTimesToBeWorn).round();
    });
    return total.round();
  }

  Widget buildOutfitCard(OutfitListItem oF, int idx) {
    if (idx >= keys.length) {
      keys.add(GlobalKey<FlipCardState>());
    }
    var cardKey = keys[idx];
    return FlipCard(
      key: cardKey,
      front: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 15.0, color: CustomColours.greenNavy()))),
            child: OutfitCard(
              key: UniqueKey(),
              outfitClothingList: oF.data.clothing,
              resetDressingRoom: widget.resetDressingRoom,
            ),
          ),
          Positioned(
            bottom: -10,
            left: 0.0,
            right: 0.0,
            child: Icon(Icons.more_horiz_outlined,
                color: CustomColours.offWhite(), size: 35.0),
          ),
        ],
      ),
      back: Stack(
        children: [
          Card(
              elevation: 5,
              color: CustomColours.greenNavy(),
              shadowColor: CustomColours.baseBlack(),
              child: Center(
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Padding(padding: EdgeInsets.all(30)),
                    SizedBox(
                        width: 75,
                        height: 75,
                        child: FlatButton(
                            color: CustomColours.greenNavy(),
                            textColor: CustomColours.offWhite(),
                            highlightColor: CustomColours.iconGreen(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Wear",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              wearOutfit(oF);
                              cardKey.currentState.toggleCard();
                            })),
                    Expanded(
                        flex: 5,
                        child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Icon(Icons.eco,
                                    color: CustomColours.accentGreen())))),
                    Expanded(
                        flex: 5,
                        child: Text('+ ' + getTotalCarmaGain(oF).toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: CustomColours.accentGreen())))
                  ]))),
          Positioned(
            top: 3,
            right: 3,
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.delete,
                  color: CustomColours.offWhite(), size: 22.0),
              onPressed: () {
                deleteOutfit(oF.id);
                cardKey.currentState.toggleCard();
              },
            ),
          )
        ],
      ),
      // onFlip: widget.resetDressingRoom,
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        child: new GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            for (int i = 0; i < this.widget.outfits.length; i++)
              buildOutfitCard(widget.outfits[i], i)
          ],
        ));
  }
}
