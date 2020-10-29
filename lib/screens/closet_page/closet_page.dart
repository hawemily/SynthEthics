import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/closet_container.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/responseObjects/getClosetResponse.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';

class Closet extends StatefulWidget {
  Closet({Key key}) : super(key: key);

  final List<String> categories = [
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

  @override
  void initState() {
    //TODO: call api to init categories from backend using collecitons
    // categories = getCategories();
    List<String> categories = widget.categories;
    clothingItems = this.getClothes();
    print(categories);
    _tabs = <Tab>[for (String c in categories) Tab(text: c)];
    super.initState();
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

  Widget generateCloset() {
    print("generatingCloset");
    return FutureBuilder<GetClosetResponse>(
      future: clothingItems,
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          return ClosetContainer(
            clothingItemObjects: snapshot.data.clothingItems, isCloset: false,
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Unable to load clothes from closet! Please contact admin for support");
        }
        return CircularProgressIndicator();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
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
          return generateCloset();
        }).toList(),
      ),
      bottomNavigationBar: NavBar(),
    );
//        ClosetContainer(clothingIds: List.generate(20, (index) => index))
  }
}
