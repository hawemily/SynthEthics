import 'package:flutter/material.dart';
import 'package:synthetics/screens/donation/donation.dart';
import 'package:synthetics/screens/home_page/home_page.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:synthetics/screens/login/login_page.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => HomePage());
      case "/closet":
        return MaterialPageRoute(builder: (context) => Closet());
      case "/donation":
        return MaterialPageRoute(builder: (context) => DonationPage());
      case "/login":
        return MaterialPageRoute(builder: (context) => LoginPage());
      default:
        print("routes generated here when bottom nav bar is pressed instead");
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
          centerTitle: true,
        ),
        body: Center(
          child: Text("Page not found!")
        )
      );
    });

  }

}

Map<Screens, String> routeMapping = {
  Screens.Home: '/',
  Screens.Login: '/login',
  Screens.Closet: '/closet',
  Screens.Donation: '/donation',
  Screens.Empty: '/empty',
};

enum Screens {
  Home,
  Closet,
  Donation,
  Empty,
  Login
}