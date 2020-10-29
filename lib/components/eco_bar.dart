import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EcoBar extends StatelessWidget {
  const EcoBar({this.current, this.max});

  final current;
  final max;
  final maxWidth = 78.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13.0,
      width: 100.0,
      margin: EdgeInsets.only(bottom:5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          Container(
            width: 15.0,
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
                      width: maxWidth * current / max,
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
