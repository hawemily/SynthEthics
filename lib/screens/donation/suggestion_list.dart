import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:synthetics/screens/donation/donation_card.dart';
import 'dart:convert';

class SuggestionsList extends StatefulWidget {
  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {

  var names = new List(5);
  var addresses = new List(5);
  var distances = new List(5);

  Future getClothingCharities() async {
    var str = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=51.497311,-0.179720&radius=5000&type=establishment&keyword=clothes+donation&key=AIzaSyAs4k7r81L8a_kk51E_piDGxHjkNS-EVp0";
    http.Response response = await http.get(str);
    var results = jsonDecode(response.body);
    setState(() {

      for (var i = 0 ; i < 5; i++) {
        this.names[i] = results['results'][i]['name'];
        this.addresses[i] = results['results'][i]['vicinity'];
      }
    });
  }

  @override
  void initState() {

    this.getClothingCharities();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(20),
      child: ListView(
        children: [
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Swipe down to hide',
                textAlign: TextAlign.center,
              )),
          for (var i = 0; i < 5; i++) DonationCard(name: (names[i] != null ? names[i] : "Loading"), address: (addresses[i] != null ? addresses[i] : "Loading"), distance: 5.0)
        ],
      ),
    );
  }
}
