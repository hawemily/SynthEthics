import 'package:flutter/material.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class InformationPage extends StatelessWidget {
  final controller = PageController(
      // initialPage: 1,
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColours.greenNavy(),
        appBar: AppBar(
          title: Text('How to Use SynthEthics',
              style: TextStyle(color: Colors.white)),
          backgroundColor: CustomColours.greenNavy(),
        ),
        body: ListView(
          children: [
            SizedBox(
                height: (MediaQuery.of(context).size.height) * 0.8,
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(25.0),
                              child: Column(children: [
                                Text("What are Carma Points?",
                                    style: TextStyle(fontSize: 28),
                                    textAlign: TextAlign.center),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            AssetImage('lib/assets/leaf.jpg'))),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                          "Carma Points help you track your progress and manage your clothing carbon footprint.",
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center),
                                      Text(
                                        "\nYou can get carma points by wearing any clothing item in your closet, wearing outfits or donating items.",
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "\nOur aim is to use these points to make users aware of their carbon footprint and fast fashion decisions!",
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            )
                          ],
                        )),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Column(children: [
                              Text("Add to Closet",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(children: [
                                  Text(
                                      "To add item to closet, simply click on + icon and scan (or upload) a picture of the clothing label.",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Image.asset(
                                      'lib/assets/add_to_closet.gif',
                                      width: double.maxFinite,
                                      height: 300.0,
                                    ),
                                  ),
                                  Text(
                                      "Upload picture and fill out all necessary information of clothing item and hit 'Save'. Your item is now in closet to be viewed at any point.",
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center),
                                ]),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 16.0)),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(children: [
                              Text("Wear Item",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/item_dashboard.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nClicking on item will direct you to its dashboard. Here you can view info about item, and wear it to gain Carma Points!",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 16.0)),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text("How to Donate?",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/donate_dashboard.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "You can donate an item by clicking DONATE from the item's dashboard. This add item to the TO BE DONATED tab in the closet where you can select other items of clothes you'd like to donate.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/donate_suggestions.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nWe will also prompt you to donate items of clothing that you've worn sufficiently or one you have not worn in a while.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/donate_centres.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nOnce selecting all items to be donated, we will redirect you to the donations map, which will show you the 5 nearest locations where you can donate your clothes.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 16.0)),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text("How do I use the dressing room?",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/add_outfit.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "Add OUTFITS that you wear often so you can easily keep track of them!",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/random_generator.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nYou can also use our RANDOM OUTFIT GENERATOR to get random outfits from your closet!",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/wear_outfit.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nTapping WEAR on an outfit updates the WEAR counts of every item in the outfit!",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 16.0)),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text("How to track Your Achievements?",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/achievements.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "Achievements can be viewed via the icon at the top left of the home page, they are records of your progrssion, and an indication of the sustainable choices you've made!",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
                              Text(
                                "\nAchievements can be earnt through earning Carma points, donating used items of clothing and more.",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              )
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: controller,
                count: 6,
                effect: ScaleEffect(
                  dotColor: Colors.white,
                  activeDotColor: CustomColours.iconGreen(),
                  activeStrokeWidth: 7,
                  radius: 8,
                  spacing: 15,
                ),
              ),
            ),
          ],
        ));
  }
}
