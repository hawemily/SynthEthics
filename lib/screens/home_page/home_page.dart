import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synthetics/components/carma_chart/carma_resolution_view.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/screens/achievements_page/achievements_page.dart';
import 'package:synthetics/screens/home_page/carma_record_viewer.dart';
import 'package:synthetics/screens/home_page/widget/right_side_drawer.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/services/initialiser/initialiser.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';

import '../../routes.dart';
import 'info_page.dart';

// Home page, currently standing in for the user home page
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _iconSize = 30.0;

  bool _openAchievements = false;

  int carmaPoints = 0;
  String uid;

  @override
  void initState() {
    // not sure if this widget will be rebuilt if uid changes
//    CurrentUser user = CurrentUser.getInstance();
//    uid = user.getUID();

    // TODO: REMOVE TESTING DATA INITIALISER
//    LocalDatabaseInitialiser.initUsers(uid);
    getUserRecords();

    super.initState();
  }

  void getUserRecords() async {
    String uid = CurrentUser.getInstance().getUID();
    final resp = await api_client.get("/getUserRecords/" + uid);

    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      carmaPoints = body["carmaPoints"];
    } else {
      print("Failed to fetch user records");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackWidgets = [
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: CustomColours.greenNavy(),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(
                Icons.emoji_events,
                size: _iconSize,
                color: CustomColours.offWhite(),
              ),
              onPressed: () {
                setState(() {
                  _openAchievements = true;
                });
              }),
          actions: [
            IconButton(
                icon: Icon(
                    Icons.info,
                    size: _iconSize,
                    color: CustomColours.offWhite()
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InformationPage()),
                  );
                }
            ),
            IconButton(
              icon: Icon(
                  Icons.settings,
                  size: _iconSize,
                  color: CustomColours.offWhite()
              ),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            )
            // HomeDropdownMenu()
          ],
        ),
        endDrawer: HomeRightDrawer(),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(children: [
                    Center(
                      child: Container(
                        color: CustomColours.offWhite(),
                        width: 400,
                        height: 180,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 4,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Icon(Icons.eco_outlined,
                                    color: CustomColours.iconGreen(),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "CARMA : " + carmaPoints.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CustomColours.greenNavy()),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                Expanded(
                  flex: 3,
                  child: CarmaRecordViewer()
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavBar(selected: 0),
      )
    ];

    stackWidgets.addAll([
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: (_openAchievements) ? Container(
          color: CustomColours.baseBlack().withOpacity(0.9),
        ) : Container(),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
      ),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: (_openAchievements) ? AchievementsPage(onClose: () {
            setState(() {
              _openAchievements = false;
            });
          },
        ) : Container(),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
      )
    ]);

    return Stack(children: stackWidgets);
  }
}
