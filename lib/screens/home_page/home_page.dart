import 'package:flutter/material.dart';
import 'package:synthetics/screens/home_page/home_page_button.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  void _gotoScannerPage() {
    Navigator.pushNamed(
        context,
        '/scanner'
    );
  }

  void _gotoEmptyPage() {
    Navigator.pushNamed(
        context,
        '/empty');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomePageButton(
              text: 'Go to scanner page',
              onPressed: _gotoScannerPage,
            ),
            HomePageButton(
              text: 'Go to empty page',
              onPressed: _gotoEmptyPage,
            )
          ],
        ),
      ),
    );
  }
}