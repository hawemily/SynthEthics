import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/screens/home_page/home_page_button.dart';
import 'package:synthetics/theme/custom_colours.dart';

import '../../routes.dart';

// Home page, currently standing in for the user home page
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final double _iconSize = 30.0;

  void _gotoEmptyPage() {
    Navigator.pushNamed(context, routeMapping[Screens.Empty]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        color: CustomColours.offWhite(),
                        width: 400,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 20),
                                width: 120.0,
                                height: 120.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image : NetworkImage("https://steamcdn"
                                            "-a.akamaihd.net/steamcommunity/pu"
                                            "blic/images/avatars/27/271540ebec"
                                            "73a4380b45350f970f5af5737d7d64_fu"
                                            "ll.jpg"),
                                    )
                                )),
                            Text(
                              "Mrs Chanandler Bong",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CustomColours.greenNavy()
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.emoji_events,
                            size: _iconSize,
                            color: CustomColours.greenNavy(),
                          ),
                          onPressed: () => print("Go to achievements")),
                        IconButton(
                            icon: Icon(
                              Icons.settings,
                              size: _iconSize,
                              color: CustomColours.greenNavy(),
                            ),
                            onPressed: () => print("Go to settings")),
                      ]
                    ),
                  ]
                ),
                DefaultTabController(
                  length: 3,
                  child: SizedBox(
                    height: 300,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          color: CustomColours.greenNavy(),
                          child: TabBar(
                            labelColor: CustomColours.greenNavy(),
                            unselectedLabelColor: CustomColours.offWhite(),
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: CustomColours.offWhite()),
                            tabs: [
                              CarmaResolutionTab(label : "WEEK"),
                              CarmaResolutionTab(label : "MONTH"),
                              CarmaResolutionTab(label : "YEAR"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              CarmaResolutionView(tempLabel : "WEEK VIEW"),
                              CarmaResolutionView(tempLabel : "MONTH VIEW"),
                              CarmaResolutionView(tempLabel : "YEAR VIEW"),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                // Column(
                //                 //
                //                 // ),
                //                 // HomePageButton(
                //                 //   text: 'Go to empty page',
                //                 //   onPressed: _gotoEmptyPage,
                //                 // )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

class CarmaResolutionView extends StatefulWidget {
  final String tempLabel;

  const CarmaResolutionView({Key key, this.tempLabel}) : super(key: key);

  @override
  _CarmaResolutionViewState createState() => _CarmaResolutionViewState();
}

class _CarmaResolutionViewState extends State<CarmaResolutionView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child : Column(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.tempLabel)
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CarmaStat(
                  statColor: CustomColours.iconGreen(),
                  statLabel: "Bought",
                  statValue: 3,
                ),
                CarmaStat(
                  statColor: CustomColours.negativeRed(),
                  statLabel: "Worn",
                  statValue: 0,
                ),
                CarmaStat(
                  statColor: CustomColours.iconGreen(),
                  statLabel: "Recycled",
                  statValue: 3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CarmaStat extends StatefulWidget {
  final Color statColor;
  final String statLabel;
  final int statValue;

  const CarmaStat({Key key, this.statColor, this.statLabel, this.statValue})
      : super(key: key);
  @override
  _CarmaStatState createState() => _CarmaStatState();
}

class _CarmaStatState extends State<CarmaStat> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: CustomColours.greenNavy(),
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.statValue.toString(),
              style: TextStyle(
                color: widget.statColor
              ),
            ),
            Text(
              widget.statLabel,
              style: TextStyle(
                color: CustomColours.offWhite()
              ),
            )
          ],
        )
      ),
    );
  }
}


class CarmaResolutionTab extends StatefulWidget {
  final String label;

  const CarmaResolutionTab({Key key, this.label}) : super(key: key);

  @override
  _CarmaResolutionTabState createState() => _CarmaResolutionTabState();
}

class _CarmaResolutionTabState extends State<CarmaResolutionTab> {
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        widget.label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



