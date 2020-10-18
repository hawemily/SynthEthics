import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';

class ClosetContainer extends StatelessWidget {
  const ClosetContainer({Key key, this.clothingIds}) : super(key: key);

  final clothingIds;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5.0),
        child: new GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
          for (var id in this.clothingIds) ClothingCard(clothingId: id)
        ],
        ));
  }
}
