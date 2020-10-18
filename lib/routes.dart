import 'package:flutter/widgets.dart';

import 'package:synthetics/screens/home_page/home_page.dart';
import 'package:synthetics/screens/example_pages/example_empty_page.dart';
import 'package:synthetics/screens/image_taker_page/image_taker_page.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';

// categories to be passed in from backend
final categories = ["tops", "bottoms", "skirts", "dresses", "outerwear", "headgear"];

// Routes for use by the MaterialApp to route between pages
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  routeMapping[Screens.Home]: (BuildContext context) => HomePage(),
  routeMapping[Screens.Empty]: (BuildContext context) => ExampleEmptyPage(),
  routeMapping[Screens.Closet]: (BuildContext context) => Closet(categories: categories),
};

// Enum representation of pages, so that we don't have to keep writing strings
// Also to keep things centralised in case of changes.
enum Screens {
  Home,
  Closet,
  Empty,
}

// Mapping between Screens and routes
Map<Screens, String> routeMapping = {
  Screens.Home: '/',
  Screens.Closet: '/closet',
  Screens.Empty: '/empty'
};


