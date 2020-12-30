import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/screens/clothing_colour_page/color_classifier.dart';
import 'package:synthetics/screens/clothing_colour_page/colour_scheme_checker.dart';
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
  CurrentUser user = CurrentUser.getInstance();
  Random random = new Random();
  Random r2 = new Random();
  ColourSchemeChecker colourChecker = ColourSchemeChecker();

  final List<Set<String>> outfitTypes = [
    {"Tops", "Bottoms", "Outerwear"},
    {"Dresses", "Outerwear"},
  ];

  @override
  void initState() {
    super.initState();
    this.randomItems = generateRandom();
  }

  Set<ClothingItemObject> generateRandom() {
    int randomOutfitType = random.nextInt(outfitTypes.length);
    var clothingItems = widget.clothingItems;
    Set<ClothingItemObject> newItems = Set();
    Set<OutfitColor> colors = Set();

    outfitTypes[randomOutfitType].forEach((type) {
      var items = clothingItems[type];
      if (items != null) {
        ClothingItemObject selectedItem = items[r2.nextInt(items.length)];
        newItems.add(selectedItem);
        print(OutfitColor.values[selectedItem.data.dominantColor]);
        colors.add(OutfitColor.values[selectedItem.data.dominantColor]);
      }
    });

    if (colourChecker.isValid(colors)) {
      return newItems;
    } else {
      return generateRandom();
    }
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
    print("Build");
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        for (var item in this.randomItems)
          () {
            print("printing item");
            print(item.data.name);
            return ClothingCard(
              clothingItem: item,
              isRandom: true,
            );
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
                      print("Random items regenerated");
                      randomItems.forEach((element) {
                        print(element.data.name);
                      });
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
