import 'package:flutter/material.dart';
import 'suggestion_list.dart';

/// Creates Bottom Sheet which hides the donation centres
/// The donation centres tapping the BottomSheetButton which displays all centres
/// The Bottom Sheet can be hidden again by scrolling down
class BottomSheetButton extends StatefulWidget {
  BottomSheetButton({Key key, this.names, this.addresses, this.distances})
      : super(key: key);

  final List names;
  final List addresses;
  final List distances;

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheetButton> {
  bool _show = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            backgroundColor: Colors.green[700],
            child: Icon(Icons.keyboard_arrow_up),
            onPressed: () {
              var sheetController = showBottomSheet(
                  context: context,
                  builder: (context) => SuggestionsList(
                        names: widget.names,
                        addresses: widget.addresses,
                        distances: widget.distances,
                      ));
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
