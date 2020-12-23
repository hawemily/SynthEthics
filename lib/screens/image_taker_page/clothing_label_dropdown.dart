import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClothingLabelDropdown extends StatefulWidget {
  final data;
  final selected;
  final label;
  final Function onChange;

  final padding;

  ClothingLabelDropdown({this.data, this.selected, this.label, this.onChange,
    this.padding = 20.0});

  @override
  ClothingLabelDropdownState createState() => ClothingLabelDropdownState();
}

class ClothingLabelDropdownState extends State<ClothingLabelDropdown> {

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> dropDownMenuItems = [];
    for (var entry in widget.data) {
      dropDownMenuItems.add(DropdownMenuItem(
        child: Text(entry),
        value: widget.data.indexOf(entry),
      ));
    }
    return Card(
      child: Container(
          padding: EdgeInsets.only(
            left: widget.padding,
            right: widget.padding,
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                labelText: widget.label,
                enabledBorder: InputBorder.none
            ),
            isExpanded: true,
            value: widget.selected,
            items: dropDownMenuItems,
            onChanged: widget.onChange,
          )),
    );
  }
}