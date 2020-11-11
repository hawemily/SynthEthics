import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/closet_container.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/responseObjects/getClosetResponse.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';

import 'closet_donation_page.dart';

enum ClosetMode {
    Normal, Select, Donate
}

class Closet extends StatefulWidget {
  Closet({Key key}) : super(key: key);

  ClosetMode mode = ClosetMode.Donate;
  final List<String> categories = [
    "items to be donated",
    "tops",
    "bottoms",
    "skirts",
    "dresses",
    "outerwear",
    "headgear"
  ];

  @override
  _ClosetState createState() => _ClosetState();
}

class _ClosetState extends State<Closet> with SingleTickerProviderStateMixin {
  List<Tab> _tabs;
  TabController _tabController;

  //Future<List<String>> categories;
   Future<GetClosetResponse> clothingItems;
   Future<GetClosetResponse> _itemsToBeDonated;

   ClosetMode _mode = ClosetMode.Normal;

  @override
  void initState() {
    super.initState();
    //TODO: call api to init categories from backend using collecitons
    // categories = getCategories();
    List<String> categories = widget.categories;
    clothingItems = this.getClothes();
//    _itemsToBeDonated = this.getDonatedItems();
    _itemsToBeDonated = clothingItems;
    print(categories);
    _tabs = <Tab>[for (String c in categories) Tab(text: c)];

    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<String>> getCategories() async {
    final resp = await api_client.get("/getAllClothingTypes");

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      final clothingTypes = body['clothingTypes'];
      return clothingTypes;
    }
  }

  Future<GetClosetResponse> getClothes() async {
    print("trying get all clothes from backend");
    final response = await api_client.get("/closet/allClothes");

    if (response.statusCode == 200) {
      print(response.body);
      final resBody = jsonDecode(response.body);
      final closet = GetClosetResponse.fromJson(resBody);
      return closet;
    } else {
      throw Exception("Failed to load closet");
    }
  }

  Future<GetClosetResponse> getDonatedItems() async {
    print("get all items marked as to be donated from backend");
    final response = await api_client.get("/closet/allDonatedItems");
    if(response.statusCode == 200) {
      print(response.body);
      final resBody = jsonDecode(response.body);
      final toBeDonated = GetClosetResponse.fromJson(resBody);
      return toBeDonated;
    } else {
      throw Exception("Failed to load donatedItems");
    }
  }

  Widget generateCloset() {
    print("generatingCloset");
    return FutureBuilder<GetClosetResponse>(
      future: clothingItems,
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          return ClosetContainer(
            _mode,
            clothingItemObjects: snapshot.data.clothingItems,
            setMode: setMode,
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Unable to load clothes from closet! Please contact admin for support");
        }
        return CircularProgressIndicator();
      }
    );
  }

  setMode(ClosetMode mode) {
    print("set mode is called $mode");
    setState(() {
      _mode = mode;
    });
  }

  Widget generateDonationPage() {
    return FutureBuilder<GetClosetResponse>(
      future: _itemsToBeDonated,
      builder: (context, snapshot) {
        print("generating donated items in generate donation page");
        if (snapshot.hasData) {
          return ClosetDonationPage(
            setMode: setMode,
            mode: _mode,
            donatedItems: snapshot.data.clothingItems
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Unable to load donated items");
        }
        return CircularProgressIndicator();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.mode);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Closet', style: TextStyle(color: Colors.black)),
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
          if (label == "items to be donated") {
            return generateDonationPage();
          } else {
            return generateCloset();
          }
        }).toList(),
      ),
      bottomNavigationBar: NavBar(selected: 1),

    );
//        ClosetContainer(clothingIds: List.generate(20, (index) => index))
  }
}
