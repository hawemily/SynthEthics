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

  void _gotoEmptyPage() {
    Navigator.pushNamed(context, routeMapping[Screens.Empty]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: CustomColours.greenNavy(),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomePageButton(
              text: 'Go to empty page',
              onPressed: _gotoEmptyPage,
            )
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
