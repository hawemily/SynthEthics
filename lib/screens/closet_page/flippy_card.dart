import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';

class FlippyCard extends ClothingCard {
  const FlippyCard(this.flipAction, {Key key, clothingItem})
      : super(key: key, clothingItem: clothingItem);

  final Function(String id, int clothingType, bool donated) flipAction;

  @override
  _FlippyCardState createState() => _FlippyCardState();
}

class _FlippyCardState extends ClothingCardState<FlippyCard> {
  ConfettiController _confettiControl;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    this.currentClothingItem = widget.clothingItem;
    currClothingItemImage = super.getImage();
    _confettiControl = ConfettiController(duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    if (_confettiControl != null) {
      _confettiControl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double donateGain = this.currentClothingItem.data.cF *
        (1 -
            this.currentClothingItem.data.currentTimesWorn /
                this.currentClothingItem.data.maxNoOfTimesToBeWorn);

    return FlipCard(
        key: cardKey,
        direction: FlipDirection.HORIZONTAL,
        onFlip: () {
          if (cardKey.currentState.isFront) {
            _confettiControl.play();
          }
        },
        onFlipDone: (status) {
          widget.flipAction(this.currentClothingItem.id, this.currentClothingItem.data.clothingType, !status);
        },
        front: super.buildBaseStack(null),
        back: Card(
            color: CustomColours.offWhite(),
            margin: EdgeInsets.all(5.0),
            child: InkWell(
                onTap: null,
                child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Stack(children: [
                      FutureBuilder<File>(
                          future: this.currClothingItemImage,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.file(snapshot.data);
                            } else if (snapshot.data == null) {
                              return Text("No image from file");
                            }
                            return LinearProgressIndicator();
                          }),
                      Opacity(
                          opacity: 0.8, child: Container(color: Colors.white)),
                      Column(children: [
                        Expanded(
                            flex: 5,
                            child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Icon(Icons.eco,
                                        color: CustomColours.iconGreen())))),
                        Expanded(
                            flex: 5,
                            child: Text('+ ' + donateGain.toString() + ' ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColours.iconGreen())))
                      ]),
                      Align(
                          alignment: Alignment.center,
                          child: ConfettiWidget(
                              confettiController: _confettiControl,
                              blastDirectionality: BlastDirectionality.explosive,
                              // blastDirection: -pi / 2,
                              shouldLoop: false,
                              minBlastForce: 20,
                              maxBlastForce: 30,
                              minimumSize: const Size(5, 5),
                              maximumSize: const Size(8, 8),
                              emissionFrequency: 0.1,
                              gravity: 0.7,
                              particleDrag: 0.2,
                              numberOfParticles: 10,
                              colors: const [
                                Colors.white,
                                Colors.green,
                                Colors.lightGreenAccent,
                                Colors.lightGreen
                              ]))
                    ])))));
  }
}
