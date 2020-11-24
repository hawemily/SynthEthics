import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/theme/custom_colours.dart';

class RandomOutfit extends StatefulWidget {
  RandomOutfit(this.clothingItems);

  final List<ClothingItemObject> clothingItems;

  @override
  _RandomOutfitState createState() => _RandomOutfitState();
}

class _RandomOutfitState extends State<RandomOutfit> {
  List<ClothingItemObject> randomItems = [];
  int noOfItems = 2;
  var types = new Set();

  @override
  void initState() {
    super.initState();
    randomItems = generateRandom();
  }

  List<ClothingItemObject> generateRandom() {
    for (var i in widget.clothingItems) {
      var type = i.data.clothingType;
      if (!types.contains(type)) {
        types.add(type);
        randomItems.add(i);
      }
    }
    return randomItems;
  }

  void saveOutfit() async {
    print("OUTFIT SELECTED");
    if (randomItems.isEmpty) {
      Navigator.pop(context, "none");
      return;
    }

    var items = [];

    for (var i in randomItems) {
      items.add(i.id);
    }

    print(jsonEncode(<String, dynamic>{'name': "outfitName", 'ids': items}));
    // put in try, loading icon
    await api_client
        .post("/postOutfit",
            body: jsonEncode(
                <String, dynamic>{'name': "outfitName", 'ids': items}))
        .then((e) {
      print("in closet container");
      print(e.statusCode);
      print(e.body);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColours.greenNavy(),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Generate Outfit'),
        ),
        body: ListView(
          children: [
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                for (var item in this.randomItems)
                  () {
                    return ClothingCard(clothingItem: item);
                  }()
              ],
            ),
            Padding(padding: EdgeInsets.all(20)),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              buttonHeight: 20,
              buttonMinWidth: 60,
              children: [
                IconButton(
                  color: CustomColours.greenNavy(),
                  icon: Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                    icon: Icon(Icons.refresh),
                    color: CustomColours.greenNavy(),
                    tooltip: 'Refresh',
                    onPressed: () => {
                          setState(() {
                            this.randomItems = generateRandom();
                          })
                        }),
                IconButton(
                  color: CustomColours.greenNavy(),
                  icon: Icon(Icons.check),
                  tooltip: 'Save',
                  onPressed: () => saveOutfit(),
                ),
              ],
            )
          ],
        ));
  }
}
