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
                              padding: EdgeInsets.all(30),
                              child: Column(children: [
                                Text("What are Carma Points?",
                                    style: TextStyle(fontSize: 28),
                                    textAlign: TextAlign.center),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.0, bottom: 20.0),
                                    child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            AssetImage('lib/assets/leaf.jpg'))),
                                Text(
                                    "Carma Points help you track your progress and manage your clothing carbon footprint.",
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.justify),
                                Text(
                                  "\nYou can get carma points by wearing any clothing item in your closet, wearing outfits or donating items.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify,
                                ),
                                Text(
                                  "\nOur aim is to use these points to make users aware of their carbon footprint and fast fashion decisions!",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify,
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
                            padding: EdgeInsets.all(30),
                            child: Column(children: [
                              Text("Add to Closet",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text(
                                  "To add item to closet, simply click on + icon and scan (or upload) a picture of the clothing label.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 16),
                                child: Image.asset(
                                  'lib/assets/add_to_closet.gif',
                                  width: double.maxFinite,
                                  height: 300.0,
                                ),
                              ),
                              Text(
                                  "Upload picture and fill out all necessary information of clothing item and hit 'Save'. Your item is now in closet to be viewed at any point.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(children: [
                              Text("Track Clothing Item",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Text(
                                  "\nClicking on item will direct you to its dashboard. Here you can view information such as material etc.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Padding(
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  child: Image.asset(
                                    'lib/assets/item_dashboard.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nMost importantly, you can track your Carma progress by seeing how many times to wear that item to fulfil your Carma debt.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Text(
                                  "\nClick on 'Wear' to gain Carma points. You can also 'Undo' this action.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(children: [
                              Text("Donate Clothing Items",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text(
                                  "You can select an item to be donated by clicking 'Donate' from the item's dashboard. This will add item to the To Be Donated tab in the closet.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/donate_Item_dashboard.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "You can also bulk select an items to be donated from Suggested Donations in closet.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/donate_suggestions.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "From 'To be Donated' you can mark items as donated once you have finally donated these items",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/donate_centres.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nUpon clicking the righmost icon in bottom nav bar, you will be redirected to a map, which will show you donation centres near you.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(children: [
                              Text("Outfits in Dressing Room",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text(
                                  "Add Outfits that you wear often so you can easily keep track of them!",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/outfit_generation.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nYou can also use our random outfit generator to save outfits you like in your closet.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/wear_outfit.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nClick on the more icon on the green bar below outfit card to wear or delete an outfit.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(children: [
                              Text("Track Your Achievements",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.center),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              Text(
                                  "Your achievement badges can be viewed via the top left icon on home page.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/achievements.gif',
                                    width: double.maxFinite,
                                    height: 300.0,
                                  )),
                              Text(
                                  "\nUnlock achievement badges by earning Carma points, donating clothing items and more.",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
                              Text(
                                  "\nThey mark your progress and are an indication of the sustainable choices you've made!",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.justify),
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
