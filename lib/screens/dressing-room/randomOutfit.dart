import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';

class RandomOutfit extends StatefulWidget {
  RandomOutfit(this.clothingItems);

  final Map<String, List<ClothingItemObject>> clothingItems;

  @override
  _RandomOutfitState createState() => _RandomOutfitState();
}

class _RandomOutfitState extends State<RandomOutfit> {
  Set<ClothingItemObject> randomItems = Set();
  int noOfItems = 2;
  bool ref;
  CurrentUser user = CurrentUser.getInstance();
  // var types = new Set();

  @override
  void initState() {
    super.initState();
    this.ref = false;
    this.randomItems = generateRandom(this.ref);
  }

  Set<ClothingItemObject> generateRandom(bool ref) {
    var clothingItems = widget.clothingItems;
    this.randomItems = Set();
    print("Hiiiiiiiiiiiiiiiiiiiiii");

    // Random random = new Random();
    clothingItems.forEach((key, value) {
      // randomItems.add(value[random.nextInt(value.length)]);
      if (!ref) {
        value.forEach((element) {
          if (element.data.brand == "Zara") this.randomItems.add(element);
        });
      } else {
        value.forEach((element) {
          if (element.data.brand == "Uqlo") this.randomItems.add(element);
        });
      }
    });
    return this.randomItems;
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
                <String, dynamic>{'uid': user.getUID(), 'name': "outfitName", 'ids': items}))
        .then((e) {
      print("in closet container");
      print(e.statusCode);
      print(e.body);
    });
    Navigator.pop(context);
  }

  Widget clothingcardbuild() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        for (var item in this.randomItems)
          () {
            print("BUILD RENDER");
            print(item.data.brand);
            // return ClothingCard(clothingItem: item);
            return Text(item.data.brand);
          }()
      ],
    );
  }

  @override
  Widget build(Object context) {
    print("++++++++++++++++");
    this.randomItems.forEach((element) {
      print(element.data.brand);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColours.greenNavy(),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Generate Outfit'),
      ),
      body: Column(
        children: [
          clothingcardbuild(),
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
                  onPressed: () => setState(() {
                        this.ref = !this.ref;
                        this.randomItems = this.generateRandom(!this.ref);
                        print("------SETSTAE---------");
                        this.randomItems.forEach((element) {
                          print(element.data.brand);
                        });
                      })),
              IconButton(
                color: CustomColours.greenNavy(),
                icon: Icon(Icons.check),
                tooltip: 'Save',
                onPressed: () => saveOutfit(),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: NavBar(selected: 3),
    );
  }
}
