import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';

class ExampleEmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empty page'),
      ),
      body: Center(
        child: Text('This page is literally empty'),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
