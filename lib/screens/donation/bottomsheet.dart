import 'package:flutter/material.dart';

import 'suggestion_list.dart';

class BottomSheetButton extends StatefulWidget {
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheetButton> {
  bool _show = true;
  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            backgroundColor: Colors.green[700],
            child: Icon(Icons.keyboard_arrow_up),
            onPressed: () {
              var sheetController = showBottomSheet(
                  context: context, builder: (context) => SuggestionsList());
              _showButton(false);
              sheetController.closed.then((value) => _showButton(true));
            })
        : Container();
  }

  void _showButton(value) {
    setState(() {
      _show = value;
    });
  }
}
