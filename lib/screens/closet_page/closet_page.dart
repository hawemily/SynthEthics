import 'package:flutter/material.dart';
import 'package:synthetics/screens/closet_page/closet_container.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';


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
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
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
        )
    );
//        ClosetContainer(clothingIds: List.generate(20, (index) => index))
  }
}
