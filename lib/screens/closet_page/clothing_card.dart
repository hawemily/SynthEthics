
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClothingCard extends StatelessWidget {
  const ClothingCard({
    Key key,
    this.clothingId
  }) : super(key: key);

  final clothingId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('You tapped on a clothing item');
      },
      child: Container(
        color: Colors.black12,
        child: Center(
          child: Text('Clothing')
        )
      )
    );
  }
}