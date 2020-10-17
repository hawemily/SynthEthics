import 'package:flutter/widgets.dart';

import 'package:synthetics/screens/home_page/home_page.dart';
import 'package:synthetics/screens/example_pages/example_empty_page.dart';
import 'package:synthetics/screens/image_taker_page/image_taker_page.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => HomePage(),
  '/scanner': (BuildContext context) => ImageTakerPage(),
  '/empty': (BuildContext context) => ExampleEmptyPage(),
  '/closet': (BuildContext context) => ClosetPage(),
};