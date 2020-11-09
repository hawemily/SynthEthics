import 'package:flutter/material.dart';
import 'package:synthetics/components/carma_chart/carma_resolution_view.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/screens/home_page/home_page_button.dart';
import 'package:synthetics/screens/home_page/info_page.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import '../../routes.dart';

// Home page, currently standing in for the user home page
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();

  final dynamic uid;

  HomePage({this.uid});
}

class HomePageState extends State<HomePage> {
  final double _iconSize = 30.0;
  String uid;

  @override
  void initState() {
    super.initState();
//    print("context: ${ModalRoute.of(context).settings.name}");
    _updateUser(widget.uid);
//    uid = ModalRoute.of(context).settings.arguments;
    // post call here to extract user details
  }

  void _updateUser(dynamic uid) {
    setState(() {
      if (uid == null) {
        print("UID SHOULD NOT BE NULL! PLEASE CHECK!");
        return;
      }
//      print("uid to string: ${uid.toString()}");
      this.uid = uid.toString();
    });
  }

  void _gotoEmptyPage() {
    Navigator.pushNamed(context, routeMapping[Screens.Empty]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColours.greenNavy(),
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.emoji_events,
              size: _iconSize,
              color: CustomColours.offWhite(),
            ),
            onPressed: () => print("Go to achievements")),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              size: _iconSize,
              color: CustomColours.offWhite(),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InformationPage()),
              );
            },
          ),
        ],
      ),
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
                        margin: EdgeInsets.only(bottom: 20, top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        fit: BoxFit.contain,
                                        image: NetworkImage("https://cdn.icon"
                                            "scout.com/icon/free/png-512/avata"
                                            "r-369-456321.png"),
                                      ))),
                            ),
                            Text(
                              "Mrs Chanandler Bong",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColours.greenNavy()),
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
                child: DefaultTabController(
                    length: 3,
                    child: SizedBox(
                      height: 300,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              color: CustomColours.greenNavy(),
                              child: TabBar(
                                labelColor: CustomColours.greenNavy(),
                                unselectedLabelColor: CustomColours.offWhite(),
                                indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: CustomColours.offWhite())),
                                tabs: [
                                  CarmaResolutionTab(label: "WEEK"),
                                  CarmaResolutionTab(label: "MONTH"),
                                  CarmaResolutionTab(label: "YEAR"),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: TabBarView(
                              children: [
                                CarmaResolutionView(
                                    resolution: CarmaViewResolution.WEEK),
                                CarmaResolutionView(
                                    resolution: CarmaViewResolution.MONTH),
                                CarmaResolutionView(
                                    resolution: CarmaViewResolution.YEAR),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
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
      bottomNavigationBar: NavBar(selected: 0),
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
            fontWeight: FontWeight.bold, color: CustomColours.offWhite()),
      ),
    );
  }
}
