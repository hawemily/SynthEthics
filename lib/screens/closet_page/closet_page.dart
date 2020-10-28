import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/closet_container.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:synthetics/services/api_client.dart';

class Closet extends StatefulWidget {
  Closet({Key key, this.categories}) : super(key:key);

  final List<String> categories;

  @override
  _ClosetState createState() => _ClosetState();
}

class _ClosetState extends State<Closet> with SingleTickerProviderStateMixin {

  List<Tab> _tabs;
  TabController _tabController;

  @override
  void initState() {
    List<String> categories = widget.categories;
    print(categories);
    _tabs = <Tab>[
      for (String c in categories) Tab(text: c)
    ];
    super.initState();
    _tabController = TabController(vsync: this, length:_tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> tryCallAPI() async {
    print("trying");
    final deployed_results = await api_client.get('https://us-central1-cfcalc.cloudfunctions.net/api/dummy');
    print(deployed_results.body);
    // final local_results = await http.get('http://10.0.2.2:5001/cfcalc/us-central1/api/dummy');
    // print(local_results.body);
  }

  @override
  Widget build(BuildContext context) {
    tryCallAPI();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('Closet', style: TextStyle(color: Colors.black)),
          bottom: TabBar(tabs: _tabs, controller: _tabController,
            isScrollable: true,
            unselectedLabelColor: Colors.black.withOpacity(0.4),
            labelColor: Colors.black,
            indicatorColor: Colors.black54,),
        ),
        body: TabBarView(
          controller: _tabController,
          children:
            _tabs.map((Tab tab) {
              final String label = tab.text;
              return ClosetContainer(clothingIds: List.generate(20, (index) => index));
            }).toList(),
        ),
        bottomNavigationBar: NavBar(),
    );
//        ClosetContainer(clothingIds: List.generate(20, (index) => index))
  }
}
