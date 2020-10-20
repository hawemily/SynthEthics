import 'package:flutter/material.dart';

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
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '$this.name',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            Text(
              '$this.address \n $this.distance',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ]),
          RaisedButton.icon(
            color: Colors.black,
            icon: Icon(Icons.navigation),
            label: Text('Navigate'),
            onPressed: () => print('Get directions'),
            shape: new CircleBorder(),
          ),
        ]),
      ),
    );
  }
}
