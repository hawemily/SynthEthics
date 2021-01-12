import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
import 'package:synthetics/screens/donation/donation_card.dart';

// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';

class SuggestionsList extends StatefulWidget {
  SuggestionsList({Key key, this.names, this.addresses, this.distances})
      : super(key: key);

  final List names;
  final List addresses;
  final List distances;

  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
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
                  name: widget.names[i] != null ? widget.names[i] : "Loading",
                  address: widget.addresses[i] != null
                      ? widget.addresses[i]
                      : "Loading",
                  distance:
                      widget.distances[i] != null ? widget.distances[i] : 0.0)
          ],
        ));
  }
}
