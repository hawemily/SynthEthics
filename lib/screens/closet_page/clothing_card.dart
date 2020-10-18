import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClothingCard extends StatelessWidget {
  const ClothingCard({Key key, this.clothingId}) : super(key: key);

  final clothingId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print('You tapped on a clothing item');
        },
        child: Container(
//              color: Colors.blue,
              margin: const EdgeInsets.all(5.0),
              child:
              Center(child: Text('Clothing ' + this.clothingId.toString())))
    );

  }
}
