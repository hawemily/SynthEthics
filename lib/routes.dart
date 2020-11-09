import 'package:flutter/widgets.dart';

import 'package:synthetics/screens/donation/donation.dart';
import 'package:synthetics/screens/home_page/home_page.dart';
import 'package:synthetics/screens/login/login_page.dart';
import 'package:synthetics/screens/example_pages/example_empty_page.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';

import 'screens/achievements_page/achievements_page.dart';

// Routes for use by the MaterialApp to route between pages
final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  routeMapping[Screens.Home]: (BuildContext context) => HomePage(),
  routeMapping[Screens.Login]: (BuildContext context) => LoginPage(),
  routeMapping[Screens.Empty]: (BuildContext context) => ExampleEmptyPage(),
  routeMapping[Screens.Donation]: (BuildContext context) => DonationPage(),
  routeMapping[Screens.Closet]: (BuildContext context) => Closet(),
  routeMapping[Screens.Achievements]: (BuildContext context) => AchievementsPage(),
};

// Enum representation of pages, so that we don't have to keep writing strings
// Also to keep things centralised in case of changes.
enum Screens {
  Home,
  Closet,
  Donation,
  Empty,
  Achievements,
  Login
}

// Mapping between Screens and routes
Map<Screens, String> routeMapping = {
  Screens.Home: '/',
  Screens.Login: '/login',
  Screens.Closet: '/closet',
  Screens.Donation: '/donation',
  Screens.Empty: '/empty',
  Screens.Achievements: '/achievements'
};


