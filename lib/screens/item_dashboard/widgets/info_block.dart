import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  final Color color;
  final String value;
  final String label;

  InfoBlock({this.color, this.value, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 25,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                value,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            )),
        Padding(padding: EdgeInsets.only(top: 5.0)),
        Text(label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ))
      ],
    );
  }
}
