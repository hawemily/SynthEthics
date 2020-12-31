import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/outfitListItem.dart';
import 'package:synthetics/screens/closet_page/outfit_card.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';

class OutfitContainer extends StatefulWidget {
  OutfitContainer({Key key, this.outfits, this.updateFunction, this.resetDressingRoom}) : super(key: key);

  final List<OutfitListItem> outfits;
  final Function updateFunction;
  final Function resetDressingRoom;

  @override
  _OutfitContainerState createState() => _OutfitContainerState();
}

class _OutfitContainerState extends State<OutfitContainer> {
  final CurrentUser user = CurrentUser.getInstance();

  Widget buildOutfitCard(OutfitListItem oF) {
    return Column(children: [
      Container(
          width: 155,
          height: 220,
          color: CustomColours.offWhite(),
          child: FlipCard(
              front: OutfitCard(outfitClothingList: oF.data.clothing, resetDressingRoom: widget.resetDressingRoom,),
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
                            highlightColor: CustomColours.iconGreen(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Wear",
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => widget.updateFunction(oF))),
                  )),
                  onFlip: widget.resetDressingRoom,
                  )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        child: new GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [for (var item in this.widget.outfits) buildOutfitCard(item)],
        ));
  }
}
