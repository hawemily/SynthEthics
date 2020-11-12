import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'action_icons_and_text.dart';

class DonationActionButton extends StatefulWidget {
  List<ActionIconsAndText> floatingActionButtons;

  DonationActionButton({this.floatingActionButtons});

  @override
  _DonationActionButtonState createState() => _DonationActionButtonState();
}

class _DonationActionButtonState extends State<DonationActionButton>
    with TickerProviderStateMixin {

  List<ActionIconsAndText> _floatingActionButtons;

  @override
  void initState() {
    _floatingActionButtons = widget.floatingActionButtons;
    super.initState();
  }


  List<SpeedDialChild> getChildren() {
    print("getting children");
    print("_floating action buttons len: ${_floatingActionButtons.length}");

    List<SpeedDialChild> widgets = [];

    _floatingActionButtons.forEach((e) {
      widgets.add(_buildFloatingButtons(e));
    });

   print("widgets length ${widgets.length}");

    return widgets;
  }

  SpeedDialChild _buildFloatingButtons(ActionIconsAndText elem) {
//    print(value);
  print(elem.onClick);
    return SpeedDialChild(
      child: elem.icon,
//        child: Row(
//          children: <Widget>[
//            elem.icon,
////            elem.text,
//          ],
//        ),
      onTap: elem.onClick
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      marginRight: 30.0,
      marginBottom: 30.0,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 20.0),
      onOpen: () => print("OPENING DIAL"),
      onClose: () => print("CLOSIN DIAL"),
      curve: Curves.easeOut,
      children: getChildren(),
    );
  }
}
