import 'package:flutter/cupertino.dart';
import 'package:synthetics/theme/custom_colours.dart';

class CarmaStat extends StatefulWidget {
  final Color statColor;
  final String statLabel;
  final int statValue;

  const CarmaStat({Key key, this.statColor, this.statLabel, this.statValue})
      : super(key: key);

  @override
  _CarmaStatState createState() => _CarmaStatState();
}

class _CarmaStatState extends State<CarmaStat> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          color: CustomColours.offWhite(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.statValue.toString(),
                style: TextStyle(
                  color: widget.statColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.statLabel,
                style: TextStyle(color: CustomColours.baseBlack()),
              )
            ],
          )),
    );
  }
}
