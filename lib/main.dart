import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart';
import 'package:synthetics/routes.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/theme/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(Client()));
}

class MyApp extends StatelessWidget {
  MyApp(this.client);

  final Client client;

  @override
  Widget build(BuildContext context) {
    api_client = new APIClient(client);

    return MaterialApp(
      title: 'SynthEthic',
      theme: appTheme(),
      initialRoute: '/start',
      routes: routes,
    );
  }
}
