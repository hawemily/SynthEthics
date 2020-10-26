import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:synthetics/screens/donation/donation_card.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class SuggestionsList extends StatefulWidget {
  SuggestionsList({Key key, this.center}) : super(key:key);

  final LatLng center;

  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {

  /* For testing: changed to 2 from 5*/
  var names = new List(2);
  var addresses = new List(2);
  var distances = new List(2);

  Future getClothingCharities() async {
    print(widget.center.latitude);
    var str =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + widget.center.latitude.toString() + "," + widget.center.longitude.toString() + "&rankby=distance&type=establishment&keyword=clothes+donation&key=AIzaSyAjd1nv48FAp72dRwalhcQWRAJ7oikwU2E";
    http.Response response = await http.get(str);
    var results = jsonDecode(response.body);
    setState(() {
      for (var i = 0; i < 2; i++) {
        this.names[i] = results['results'][i]['name'];
        this.addresses[i] = results['results'][i]['vicinity'];
        double lat = results['results'][i]['geometry']['location']['lat'];
        double lng = results['results'][i]['geometry']['location']['lng'];
        double res = Geolocator.distanceBetween(widget.center.latitude, widget.center.longitude, lat, lng);
        res = res / 1000;
        this.distances[i] = double.parse(res.toStringAsFixed(2));
        /* Calculate distance from curr LatLng and one derived from geolocator */
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
          for (var i = 0; i < 2; i++)
            DonationCard(
                name: (names[i] != null ? names[i] : "Loading"),
                address: (addresses[i] != null ? addresses[i] : "Loading"),
                distance: (distances[i] != null ? distances[i] : 0.0))
        ],
      ),
    );
  }
}
