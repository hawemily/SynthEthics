import 'package:flutter/widgets.dart';
import 'package:synthetics/screens/clothing_colour_page/clothing_colour_page.dart';

import 'package:synthetics/screens/donation/donation.dart';
import 'package:synthetics/screens/dressing-room/dressing_room.dart';
import 'package:synthetics/screens/home_page/home_page.dart';
import 'package:synthetics/screens/login/sign_in_or_register_with_email.dart';
import 'package:synthetics/screens/startup_screen.dart';
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
  routeMapping[Screens.Start]: (BuildContext context) => StartupScreen(),
  routeMapping[Screens.DressingRoom]: (BuildContext context) => DressingRoom(),
  routeMapping[Screens.ColourRoom]: (BuildContext context) =>
      ClothingColourPage(),
  routeMapping[Screens.EmailSignIn]: (BuildContext context) =>
      SignInOrRegisterWithEmailPage(),
};

// Enum representation of pages, so that we don't have to keep writing strings
// Also to keep things centralised in case of changes.
enum Screens {
  Home,
  Closet,
  Donation,
  Empty,
  Login,
  Start,
  DressingRoom,
  ColourRoom,
  EmailSignIn,
}

// Mapping between Screens and routes
Map<Screens, String> routeMapping = {
  Screens.Home: '/',
  Screens.Login: '/login',
  Screens.Closet: '/closet',
  Screens.Donation: '/donation',
  Screens.Empty: '/empty',
  Screens.Start: '/start',
  Screens.DressingRoom: '/dressingRoom',
  Screens.ColourRoom: '/colour',
  Screens.EmailSignIn: '/emailSignIn'
};
