import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/responseObjects/getClosetResponse.dart';
import 'package:synthetics/responseObjects/getOutfitResponse.dart';
import 'package:synthetics/screens/closet_page/closet_container.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/screens/dressing-room/randomOutfit.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/theme/custom_colours.dart';
import '../closet_page/outfit_card.dart';
import 'outfitContainer.dart';

class DressingRoom extends StatefulWidget {
  @override
  _DressingRoomState createState() => _DressingRoomState();
}

class _DressingRoomState extends State<DressingRoom> {
  Future<GetOutfitResponse> outfits;

  //tentative: gets all clothing items from closet
  Future<GetClosetResponse> clothingItems;
  List<ClothingItemObject> randomClothing = [];
  @override
  void initState() {
    super.initState();
    clothingItems = getClothes();
    outfits = this.getOutfits();
  }

  // Get all clothes from closet
  Future<GetClosetResponse> getClothes() async {
    print("trying get all clothes from backend");
    final response = await api_client.get("/closet/allClothes");

    if (response.statusCode == 200) {
//      print("respBody: ${response.body}");
      final resBody = jsonDecode(response.body);
      final closet = GetClosetResponse.fromJson(resBody);
//      print("itemsInCloset");

      closet.clothingTypes.forEach((element) {
        randomClothing.addAll(element.clothingItems);
      });
      print("Hiiiiiiiiiiiiiiiiiiiiiiiiii");
      print(closet);
      return closet;
    } else {
      throw Exception("Failed to load closet");
    }
  }

  // List<ClothingItemObject> getRandomOutfit() {
  //   //do something
  //   return [];
  // }

  Future<GetOutfitResponse> getOutfits() async {
    print("trying get all outfits from backend");
    final response = await api_client.get("/outfits");

    if (response.statusCode == 200) {
      print(response.body);
      final resBody = jsonDecode(response.body);
      final closet = GetOutfitResponse.fromJson(resBody);
      return closet;
    } else {
      throw Exception("Failed to load closet");
    }
  }

  Widget generateOutfits() {
    return FutureBuilder<GetOutfitResponse>(
        future: outfits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return OutfitContainer(
              outfits: snapshot.data.outfits,
            );
          } else if (snapshot.hasError) {
            return Text(
                "Unable to load clothes from closet! Please contact admin for support");
          }
          return CircularProgressIndicator();
        });
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColours.greenNavy(),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Dressing Room'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: generateOutfits(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Closet(selectingOutfit: true))).then((value) {
                  setState(() {
                    outfits = this.getOutfits();
                  });
                });
              },
              label: Text('Add Outfit'),
              icon: Icon(Icons.add),
            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RandomOutfit(this.randomClothing))).then((value) {
                  setState(() {
                    outfits = this.getOutfits();
                  });
                });
              },
              label: Text('Add Outfit'),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(selected: 3),
    );
  }
}
