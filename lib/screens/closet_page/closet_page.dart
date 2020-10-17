import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';

class ClosetPage extends StatefulWidget {
  @override
  ClosetPageState createState() => ClosetPageState();
}

class ClosetPageState extends State<ClosetPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Closet'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClothingCard(
              clothingId: 'hehe'
            )
          ],
        ),
      ),
    );
  }
}