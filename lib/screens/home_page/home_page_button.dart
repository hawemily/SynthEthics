
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageButton extends StatelessWidget {
  const HomePageButton({
    Key key,
    this.text,
    this.onPressed
  }) : super(key: key);

  final text;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
          color: Colors.lightGreen,
          textColor: Colors.white,
          child: Text(this.text),
          padding: EdgeInsets.all(15),
          onPressed: this.onPressed
    );
  }
}
