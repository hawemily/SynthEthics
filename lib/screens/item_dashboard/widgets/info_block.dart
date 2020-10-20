import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  final Color color;
  final String value;
  final String label;

  InfoBlock({this.color, this.value, this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110.0,
      height: 130,
      child: Card(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, color: color),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.blueGrey),
        ),
      ])),
    );
  }
}
