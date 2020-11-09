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
                                    textAlign: TextAlign.center),
                                Padding(padding: EdgeInsets.only(top: 16.0)),
                                Text(
                                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center),
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
                                  textAlign: TextAlign.center),
                              Padding(padding: EdgeInsets.only(top: 16.0)),
                              Text(
                                  "It covers scanning a clothing label, adding items to the closet. Once in the closet, the user can access the item's dashboard page that has access to various information about the item such as material, Carma points, progress bar, etc. The user can choose to donate clothing items and can view the nearest donation centers near them.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
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
                                  textAlign: TextAlign.center),
                              Padding(padding: EdgeInsets.only(top: 16.0)),
                              Text(
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
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
                                  textAlign: TextAlign.center),
                              Padding(padding: EdgeInsets.only(top: 16.0)),
                              Text(
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
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
                                  textAlign: TextAlign.center),
                              Padding(padding: EdgeInsets.only(top: 16.0)),
                              Text(
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center),
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
