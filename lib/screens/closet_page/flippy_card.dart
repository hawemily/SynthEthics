import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/theme/custom_colours.dart';

class FlippyCard extends ClothingCard {
  FlippyCard(this.flipAction, this.initFlip, {Key key, clothingItem})
      : super(key: key, clothingItem: clothingItem);

  final Function(String id, bool donated) flipAction;
  bool initFlip;

  @override
  _FlippyCardState createState() => _FlippyCardState();
}

class _FlippyCardState extends ClothingCardState<FlippyCard> {
  ConfettiController _confettiControl;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.currentClothingItem = widget.clothingItem;
    currClothingItemImage = super.getImage();
    super.returnTimesWorn();
    _confettiControl =
        ConfettiController(duration: const Duration(milliseconds: 300));
    if (widget.initFlip) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        cardKey.currentState.toggleCard();
      });
    }
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
//    double donateGain = this.currentClothingItem.data.cF *
//        (1 -
//            this.currentClothingItem.data.currentTimesWorn /
//                this.currentClothingItem.data.maxNoOfTimesToBeWorn);
    final double DONATION_CONST = 0.1;
    double donateGain = this.currentClothingItem.data.cF * DONATION_CONST;

    return FlipCard(
        key: cardKey,
        direction: FlipDirection.HORIZONTAL,
        onFlip: () {
          if (cardKey.currentState.isFront) {
            _confettiControl.play();
          }
        },
        onFlipDone: (status) {
          widget.flipAction(this.currentClothingItem.id, !status);
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
                                        color: CustomColours.accentGreen())))),
                        Expanded(
                            flex: 5,
                            child: Text(
                                '+ ' + (donateGain.round()).toString() + ' ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColours.accentGreen())))
                      ]),
                      Align(
                          alignment: Alignment.center,
                          child: ConfettiWidget(
                              confettiController: _confettiControl,
                              blastDirectionality:
                                  BlastDirectionality.explosive,
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
