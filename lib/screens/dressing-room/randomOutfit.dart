import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';

class RandomOutfit extends StatefulWidget {
  const RandomOutfit(this.clothingItems, {Key key}) : super(key: key);

  final Map<String, List<ClothingItemObject>> clothingItems;

  @override
  _RandomOutfitState createState() => _RandomOutfitState();
}

class _RandomOutfitState extends State<RandomOutfit> {
  Set<ClothingItemObject> randomItems = Set();
  int noOfItems = 2;
  CurrentUser user = CurrentUser.getInstance();
  Random random = new Random();
  Random r2 = new Random();

  final List<Set<String>> outfitTypes = [
    {"Tops", "Bottoms", "Outerwear"},
    {"Dresses", "Outerwear"},
  ];

  @override
  void initState() {
    super.initState();
    this.randomItems = generateRandom();
    // print("RANDOM CLOTHING");
    // widget.clothingItems.forEach((key, value) {
    //   print(key);
    //   print(value.length);
    // });
  }

  Set<ClothingItemObject> generateRandom() {
    var clothingItems = widget.clothingItems;

    int randomOutfitType = random.nextInt(outfitTypes.length);

    setState(() {
      outfitTypes[randomOutfitType].forEach((type) {
        var items = clothingItems[type];
        this.randomItems.add(items[r2.nextInt(items.length)]);
      });
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
            body: jsonEncode(<String, dynamic>{
              'uid': user.getUID(),
              'name': "outfitName",
              'ids': items
            }))
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
            print("rendered");
            return ClothingCard(clothingItem: item);
          }()
      ],
    );
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
                  onPressed: () {
                    setState(() {
                      this.randomItems.clear();
                      this.randomItems = this.generateRandom();
                    });
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
      ),
      bottomNavigationBar: NavBar(selected: 3),
    );
  }
}
