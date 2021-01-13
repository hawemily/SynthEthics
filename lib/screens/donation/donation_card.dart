import 'package:flutter/material.dart';

/// Displays information on each donation center
class DonationCard extends StatelessWidget {
  final String name;
  final String address;
  final double distance;

  DonationCard({this.name, this.address, this.distance});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        margin: EdgeInsets.all(5.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              flex: 8,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      softWrap: true,
                    ),
                    Text(
                      address + '\n' + '$distance kilometers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ])),
          Expanded(
              flex: 2,
              child: IconButton(
                  icon: Icon(Icons.navigation, color: Colors.blue),
                  onPressed: null)),
        ]),
      ),
    );
  }
}
