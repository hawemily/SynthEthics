import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:synthetics/routes.dart';

import 'package:synthetics/theme/style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SynthEthic',
      theme: appTheme(),
      initialRoute: '/',
      routes: routes,
    );
  }
}

