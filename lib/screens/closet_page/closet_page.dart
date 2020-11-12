import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synthetics/requestObjects/donated_item_metadata.dart';
import 'package:synthetics/requestObjects/items_to_donate_request.dart';
import 'package:synthetics/responseObjects/clothingTypeObject.dart';
import 'package:synthetics/screens/closet_page/closet_container.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/screens/closet_page/closet_suggestion_page.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/responseObjects/getClosetResponse.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/services/current_user.dart';

import 'closet_donation_page.dart';

enum ClosetMode { Normal, Select, Donate }

class Closet extends StatefulWidget {
  Closet({Key key}) : super(key: key);

  final List<String> categories = [
    "Tops",
    "Bottoms",
    "Skirts",
    "Dresses",
    "Outerwear",
    "Headgear",
    "to be donated",
    "suggested donations"
  ];

  @override
  _ClosetState createState() => _ClosetState();
}

class _ClosetState extends State<Closet> with SingleTickerProviderStateMixin {
  List<Tab> _tabs;
  TabController _tabController;

  //Future<List<String>> categories;
  Future<GetClosetResponse> clothingItems;
  Future<ClothingTypeObject> confirmedDonations;
  Set<DonatedItemMetadata> unconfirmedDonations = Set();

  ClosetMode _mode = ClosetMode.Normal;
  String uid = CurrentUser.getInstance().getUID();

  @override
  void initState() {
    super.initState();
    //TODO: call api to init categories from backend using collecitons
    // categories = getCategories();
    List<String> categories = widget.categories;
    confirmedDonations = this.getDonatedItems();
    clothingItems = this.getClothes();

//    confirmedDonations = ;
    print(categories);
    _tabs = <Tab>[for (String c in categories) Tab(text: c)];

    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  setMode(ClosetMode mode) {
    print("set mode is called $mode");
    setState(() {
      _mode = mode;
    });
    if (mode == ClosetMode.Normal) {
      // TODO: CALL API AND SEND SET OF CLOTHES TO BE DONATED TO BACKEND yipee and UPDATE clothing lists
      donateSelected();
    }
  }

  Future<List<String>> getCategories() async {
    final resp = await api_client.get("/getAllClothingTypes");

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      final clothingTypes = body['clothingTypes'];
      return clothingTypes;
    }
  }

  Future<ClothingTypeObject> getDonatedItems() async {
    print("get all items marked as to be donated from backend");
    final response = await api_client.get("/closet/allDonatedItems");

    if (response.statusCode == 200) {
      print("respBodyInGetDonatedIitems: ${response.body}");
      final resBody = jsonDecode(response.body);
      final toBeDonated = ClothingTypeObject.fromJson(resBody);
      print("final to be donated list: ");
      toBeDonated.clothingItems.forEach((element) {print(element);});
      return toBeDonated;
    } else {
      throw Exception("Failed to load donatedItems");
    }
  }

  Future<GetClosetResponse> getClothes() async {
    print("trying get all clothes from backend");
    final response = await api_client.get("/closet/allClothes");

    if (response.statusCode == 200) {
//      print("respBody: ${response.body}");
      final resBody = jsonDecode(response.body);
      final closet = GetClosetResponse.fromJson(resBody);
//      print("itemsInCloset");
//      closet.clothingTypes.forEach((element) {print(element.clothingType); print(element.clothingItems);});
      return closet;
    } else {
      throw Exception("Failed to load closet");
    }
  }



  bool isSelectedForDonation(String id) {
    return unconfirmedDonations.firstWhere((el) => el.id == id,
        orElse: () => null) !=
        null;
  }

  void donateClothingItem(String id, bool toDonate) {
    print(id);
    print(toDonate);
    if (toDonate) {
      unconfirmedDonations.add(new DonatedItemMetadata(id));
    } else {
      unconfirmedDonations.remove(new DonatedItemMetadata(id));
    }
    print(unconfirmedDonations.length);
  }

  void donateSelected() {
    print(unconfirmedDonations);
    ItemsToDonateRequest req = new ItemsToDonateRequest(uid,
        unconfirmedDonations.length == 0 ? [] : unconfirmedDonations.toList());
    api_client.post("/markedAsDonate", body: jsonEncode(req));
    print("in closet container");
    // setMode(ClosetMode.Normal);
    unconfirmedDonations.clear();
    // TODO: navigate back to donations and passing back the set of clothes to donate
  }

  Widget generateCloset(String type) {
//    print("generatingCloset");
    return FutureBuilder<GetClosetResponse>(
        future: clothingItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
//            print("String type: $type");

            List<ClothingTypeObject> clothingTypes = snapshot.data.clothingTypes.where((e) {
              return e.clothingType == type;
            }
            ).toList();
//            print("clothingTypes list: ${clothingTypes}");
            List<ClothingItemObject> ls = clothingTypes.first.clothingItems;
            
            return ClosetContainer(_mode,
                clothingItemObjects: ls,
                setMode: setMode,
                donate: donateClothingItem,
                isUnconfirmedDonation: isSelectedForDonation);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text(
                "Unable to load clothes from closet! Please contact admin for support");
          }
          return Center(child:CircularProgressIndicator());
        });
  }

  Widget generateDonationPage() {
    print("genreating Donation page! on line 186");
    return FutureBuilder<ClothingTypeObject>(
        future: confirmedDonations,
        builder: (context, snapshot) {
          print("generating donated items in generate donation page");
          if (snapshot.hasData) {
            return ClosetDonationPage(
                setMode: setMode,
                mode: _mode,
                donatedItems: snapshot.data.clothingItems);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Unable to load donated items");
          }
          return Center(child:CircularProgressIndicator());
        });
  }

  Widget generateSuggestionPage() {
    print("generating suggestion page");
    return FutureBuilder<GetClosetResponse>(
        future: clothingItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ClothingItemObject> allSuggestions = [];

            snapshot.data.clothingTypes.forEach((i) {

              List<ClothingItemObject> listClothingItems = i.clothingItems;
              listClothingItems.forEach((element) {
                DateTime lastWorn = DateTime.parse(element.data.lastWornDate);
                if (lastWorn.difference(DateTime.now()).inDays < 30) {
                  allSuggestions.add(element);
                }
              });

            });

            return ClosetSuggestionPage(
                setMode: setMode,
                mode: _mode,
                suggestedItems: allSuggestions,
                donate: donateClothingItem,
                isUnconfirmedDonation: isSelectedForDonation);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Unable to load suggested items");
          }
          return Center(child:CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    print(_mode);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(_mode == ClosetMode.Donate ? 'Select Donations' : 'Closet',
            style: TextStyle(color: Colors.black)),
        bottom: TabBar(
          tabs: _tabs,
          controller: _tabController,
          isScrollable: true,
          unselectedLabelColor: Colors.black.withOpacity(0.4),
          labelColor: Colors.black,
          indicatorColor: Colors.black54,
        ),
      ),
      // call future builder here
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((Tab tab) {
          final String label = tab.text;
          if (label == "to be donated") {
            return generateDonationPage();
          } else if (label == "suggested donations") {
            return generateSuggestionPage();
          } else {
            return generateCloset(tab.text);
          }
        }).toList(),
      ),
      bottomNavigationBar: NavBar(selected: 1),
    );
//        ClosetContainer(clothingIds: List.generate(20, (index) => index))
  }
}