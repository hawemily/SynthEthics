import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/theme/custom_colours.dart';

class CarmaPointDetails extends StatefulWidget {
  final int points;
  final bool hasStarted;
  final bool loading;
  final bool valid;

  CarmaPointDetails({this.points, this.hasStarted, this.loading, this.valid});

  @override
  CarmaPointDetailsState createState() => CarmaPointDetailsState();
}

class CarmaPointDetailsState extends State<CarmaPointDetails> {
  Color carmaWidgetColour;
  String carmaText;

  void _getCarmaInfo() {
    if (!widget.hasStarted) {
      carmaWidgetColour = CustomColours.greenNavy();
      carmaText = "Fill in the details below and lets get started!";
    } else {
      if (widget.valid && widget.points > 0) {
        // Have some carma points
        setState(() {
          carmaWidgetColour = CustomColours.iconGreen();
          carmaText = "${widget.points} Carma Points!";
        });
      } else {
        // Display failed
        setState(() {
          carmaWidgetColour = Colors.red;
          carmaText =
          "Oops. We can't seem to get accurate readings, is the information below correct?";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.loading) {
      _getCarmaInfo();
      return Card(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Text(carmaText, style: TextStyle(color: Colors.white))),
        ),
        color: carmaWidgetColour,
      );
    } else {
      return Card(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator())));
    }
  }
}
