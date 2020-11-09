import 'package:flutter/material.dart';
import 'const.dart';

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
        Text(
          value,
          style: TextStyle(
            fontSize: 40,
            color: color,
          ),
        ),
        Text(label, style: kSubTextStyle),
      ],
    );
  }
}
