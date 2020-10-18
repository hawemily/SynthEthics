import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';

class ClothingCard extends StatelessWidget {
  const ClothingCard({Key key, this.clothingId}) : super(key: key);

  final clothingId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print('You tapped on a clothing item');
        },
        child: Card(
            color: Colors.blue,
            margin: EdgeInsets.all(5.0),
            child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Stack(children: <Widget>[
                  Container( // to be replaced with image
                      color: Colors.grey,
                      alignment: Alignment.center,
                      height: 147,
                      child:
                          Text("Clothing Image " + this.clothingId.toString())),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: EcoBar(current: 20, max: 20)
                  )
                ])
            )
        )
    );
  }
}
