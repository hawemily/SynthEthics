import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EcoBar extends StatelessWidget {
  EcoBar({this.current, this.max});

  final current;
  final max;
  var maxWidth;
  var barWidth;

  @override
  Widget build(BuildContext context) {
    this.barWidth = MediaQuery.of(context).size.width * 0.25;
    this.maxWidth = barWidth * 0.8 - 5.5;
    return Container(
      height: 13.0,
      width: barWidth,
      margin: EdgeInsets.only(bottom:5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          Container(
            width: (barWidth * 0.2) - 1.5,
            margin: EdgeInsets.fromLTRB(1.5, 1.0, 0, 1.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Icon(
                Icons.eco,
                color: Colors.green,
                size: 11.0,
              )
            )
          ),
          Stack(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: maxWidth,
                      margin: EdgeInsets.fromLTRB(0.5, 2.5, 5.0, 2.5),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20)
                      ),
                    )
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: min(maxWidth * current / max, maxWidth),
                      margin: EdgeInsets.fromLTRB(0.5, 2.5, 3.0, 2.5),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20)
                      ),
                    )
                )
              ]
          )
        ],
      )
    );
  }
}
