import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/closet_container.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/theme/custom_colours.dart';

class Closet extends StatefulWidget {
  Closet({Key key, bool isSelect}) : super(key: key) {
    if (isSelect != null) {
      this.isSelect = true;
    }
  }

  final List<String> categories = [
    "tops",
    "bottoms",
    "skirts",
    "dresses",
    "outerwear",
    "headgear"
  ];
  bool isSelect = false;

  @override
  _ClosetState createState() => _ClosetState();
}

class _ClosetState extends State<Closet> with SingleTickerProviderStateMixin {
  List<Tab> _tabs;
  TabController _tabController;

  //Future<List<String>> categories;
  // Future<List<Map<String, dynamic>>> clothingItems

  @override
  void initState() {
    //TODO: call api to init categories from backend using collecitons
    // categories = getCategories();
    List<String> categories = widget.categories;

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

//  Future<List<String>> getCategories() async {
//    final resp = await api_client.get("/getAllClothingTypes");
//
//    if (resp.statusCode == 200) {
//      final body = jsonDecode(resp.body);
//      final clothingTypes = body['clothingTypes'];
//      return clothingTypes;
//    }
//  }
//
//  Future<List<Map<String, dynamic>>> getClothes() async {
//    print("trying get all clothes from backend");
//    final response = await api_client.get("/closet/allClothes");
//
//    if (response.statusCode == 200) {
//      print(response.body);
//      final resBody = jsonDecode(response.body);
//      final closet = resBody['clothingItems'];
//      return closet;
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColours.greenNavy(),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Closet', style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          tabs: _tabs,
          controller: _tabController,
          isScrollable: true,
          unselectedLabelColor: Colors.white.withOpacity(0.4),
          labelColor: Colors.white,
          indicatorColor: Colors.white54,
        ),
      ),
      // call future builder here
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((Tab tab) {
          final String label = tab.text;
          return ClosetContainer(
              clothingIds: List.generate(20, (index) => index),
              isSelect: widget.isSelect);
        }).toList(),
      ),
      bottomNavigationBar: NavBar(),
    );
//        ClosetContainer(clothingIds: List.generate(20, (index) => index))
  }
}
