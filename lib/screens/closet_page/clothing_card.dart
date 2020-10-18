import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';

class ClothingCard extends StatelessWidget {
  const ClothingCard({Key key, this.clothingId}) : super(key: key);

  final clothingId;

  @override
  Widget build(BuildContext context) {
    return Card(
            color: Colors.blue,
            margin: EdgeInsets.all(5.0),
            child: InkWell(
                onTap: () => {print("object is being tapped")},
                child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Stack(children: <Widget>[
                  Ink( // to be replaced with image
                      color: Colors.grey,
                      width: 147,
                      height: 147,
                      child:
                          Container(
                              child:Text("Clothing Image " + this.clothingId.toString()),
                              alignment: Alignment.center,
                          ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: EcoBar(current: 20, max: 20)
                  ),
                ])
            ))

        );
  }
}

