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
        body: Column(
          children: [
            SizedBox(
                height: (MediaQuery.of(context).size.height) * 0.8,
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 16.0)),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(children: [
                                Text("What are Carma Points?",
                                    style: TextStyle(fontSize: 28),
                                    textAlign: TextAlign.left),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            AssetImage('lib/assets/leaf.jpg'))),
                                Text(
                                    "Carma Points are what you accumulate in our application to help you track your progress and lessen your clothing carbon footprint.",
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.left),
                                Text("\nYou can get carma points from lots of different ways such as wearing any clothing item in your closet, donating items after you've worn them the suggested number of times, or simply just donating them." ,
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.left,),
                                Text("\nOur aim is to use these points to keep users such as yourself accountable to your fast fashion decisions!" ,
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left,),
                              ]),
                            )
                          ],
                        )),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 16.0)),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text("How to Scan?",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.left),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/scanner.png',
                                    width: double.maxFinite,
                                    height: 100.0,
                                  )),
                              Text("Scanning an item is simple! Just click on the PLUS icon in the middle of the navigation bar at the bottom of the screen then take a picture (or upload a pre-taken pictue) of the clothing tag of the item you'd like to add to your closet.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left),
                              Text("\nOur super cool fast fashion scanner will detect the materials used and the country the item was made in and all these numbers will contribute to calculating the number of times we recommend you to wear the item to make it's carbon footprint worth it!",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 16.0)),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text("How to Add to Closet?",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.left),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/closet.png',
                                    width: double.maxFinite,
                                    height: 100.0,
                                  )),
                              Text("After scanning an item and making sure all details are correct, simply press the ADD TO CLOSET button. This will add the clothing item to the closet and you can access it there at any point.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left),
                              Text("\nIf you've worn a clothing item and would like to track its usage (and earn some carma points for it), click on the picture of the item in the closet and tap the WEAR button to indicate that you've worn it an additional time. This should be shown in the circular progress bar around the picture of the item!",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 16.0)),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text("How to Donate?",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.left),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: Image.asset(
                                    'lib/assets/heart.png',
                                    width: double.maxFinite,
                                    height: 100.0,
                                  )),
                              Text("If you'd like to donate an individual item, simply click DONATE from the item's dashboard (accessed when clicking on the picture of an item in the closet). This will redirect you to a TO BE DONATED tab in the closet where you can select other items of clothes you'd like to donate.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left),
                              Text("\nWe will also prompt you to donate items of clothing that you've worn a sufficient amount of time or one you have not worn in a while (so others can get some use out of it). Once selecting all items to be donated, we will redirect you to the donations map, which will show you your location as well as the 5 nearest locations that you can donate your clothes at.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 16.0)),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text("How to track Your Achievements?",
                                  style: TextStyle(fontSize: 28),
                                  textAlign: TextAlign.left),
                              Padding(padding: EdgeInsets.only(top: 16.0, bottom: 16.0), child: Image.asset(
                                    'lib/assets/trophy.png',
                                    width: double.maxFinite,
                                    height: 100.0,
                                  )),
                              Text(
                                  "Achievements can be viewed via the icon at the top left of the home page, they are records of your progrssion, and an indication of the sustainable choices you've made!",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left),
                              Text(
                                "\nAchievements can be earnt through earning Carma points, donating used items of clothing and more.",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left,
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
              child: SmoothPageIndicator(
                controller: controller,
                count: 5,
                effect: ScaleEffect(
                  dotColor: Colors.white,
                  activeDotColor: CustomColours.iconGreen(),
                  activeStrokeWidth: 7,
                  // activeDotScale: .7,
                  radius: 8,
                  spacing: 15,
                ),
              ),
            ),
          ],
        ));
  }
}
