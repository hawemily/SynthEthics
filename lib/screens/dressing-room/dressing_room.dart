import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/responseObjects/getClosetResponse.dart';
import 'package:synthetics/responseObjects/getOutfitResponse.dart';
import 'package:synthetics/responseObjects/outfitListItem.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:synthetics/screens/dressing-room/randomOutfit.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'outfitContainer.dart';

class DressingRoom extends StatefulWidget {
  @override
  _DressingRoomState createState() => _DressingRoomState();
}

class _DressingRoomState extends State<DressingRoom> {
  Future<GetOutfitResponse> outfits;
  CurrentUser user = CurrentUser.getInstance();

  //tentative: gets all clothing items from closet
  Future<GetClosetResponse> clothingItems;
  Map<String, List<ClothingItemObject>> randomClothing = new Map();

  @override
  void initState() {
    super.initState();
    clothingItems = getClothes();
    outfits = this.getOutfits();
  }

  Future<void> updateAllItems(OutfitListItem oF) async {
    List<ClothingItemObject> clothing = oF.data.clothing;

    List<String> clothingIds = new List(clothing.length);
    List<double> timesWorns = new List(clothing.length);
    List<int> carmaGains = new List(clothing.length);

    int i = 0;
    for (ClothingItemObject c in clothing) {
      clothingIds[i] = c.id;
      timesWorns[i] = c.data.currentTimesWorn + 1;
      carmaGains[i] = (c.data.cF / c.data.maxNoOfTimesToBeWorn).round();
      i++;
    }

    await api_client
        .post("/updateOutfit",
            body: jsonEncode(<String, dynamic>{
              'uid': user.getUID(),
              'clothingIds': clothingIds,
              'timesWorns': timesWorns,
              'lastWorn': DateTime.now().toString(),
              'carmaGains': carmaGains
            }))
        .then((e) {
      print(e.statusCode);
      print(e.body);
    });

    resetDressingRoom();
  }

  // Get all clothes from closet
  Future<GetClosetResponse> getClothes() async {
    final response =
        await api_client.get("/closet/allClothes/" + user.getUID());
    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      final closet = GetClosetResponse.fromJson(resBody);
      closet.clothingTypes.forEach((element) {
        if (element.clothingItems.isNotEmpty)
          randomClothing[element.clothingType] = element.clothingItems;
      });

      return closet;
    } else {
      throw Exception("Failed to load closet");
    }
  }

  Future<GetOutfitResponse> getOutfits() async {
    final response = await api_client.get("/outfits/" + user.getUID());

    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      final outfits = GetOutfitResponse.fromJson(resBody);
      print("printing getOutfits");
      print(resBody);
      return outfits;
    } else {
      throw Exception("Failed to load closet");
    }
  }

  void resetDressingRoom() {
    setState(() {
      outfits = this.getOutfits();
    });
  }

  Widget generateOutfits() {
    return FutureBuilder<GetOutfitResponse>(
        future: outfits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return OutfitContainer(
              outfits: snapshot.data.outfits,
              updateFunction: updateAllItems,
              resetDressingRoom: resetDressingRoom,
            );
          } else if (snapshot.hasError) {
            return Text(
                "Unable to load clothes from closet! Please contact admin for support");
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColours.greenNavy(),
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.only(
          bottom: 80.0,
          left: 30,
          right: 30,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: CustomColours.greenNavy(),
              heroTag: null,
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
              child: Icon(
                Icons.add,
                size: 33,
              ),
            ),
            FloatingActionButton(
                backgroundColor: CustomColours.greenNavy(),
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RandomOutfit(this.randomClothing))).then((value) {
                    if (value != "none") {
                      setState(() {
                        outfits = this.getOutfits();
                      });
                    }
                  });
                },
                child: Image.asset(
                  'lib/assets/random.png',
                  width: 33,
                  height: 33.0,
                )),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(selected: 3),
    );
  }
}
