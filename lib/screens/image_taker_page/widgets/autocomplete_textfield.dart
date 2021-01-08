import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';

class AutoTextField extends StatefulWidget {
  final List data;

  final String defaultText;
  final String label;

  final Function onSelected;

  AutoTextField({this.data, this.defaultText, this.label, this.onSelected});

  @override
  _AutoTextFieldState createState() => _AutoTextFieldState();
}

class _AutoTextFieldState extends State<AutoTextField> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    this.controller.text = widget.defaultText;
    super.initState();
  }

  Widget _itemBuilder(context, suggestion) {
    return Card(
        child: Container(
            child: Text(suggestion)
        )
    );
  }

  bool _match(pattern, item) {
    return item.toLowerCase().startsWith(pattern.toLowerCase());
  }

  Future<List> _suggestionsCallback(pattern) async{
    List matches = [];
    for (String item in widget.data) {
      if (_match(pattern, item)) {
        matches.add(item);
      }
    }
    return matches;
  }

  void _onSuggestionSelected(suggestion) {
    controller.text = suggestion;
    widget.onSelected(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: this.controller,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: widget.label,
            contentPadding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            hintText: this.controller.text
          )
        ),
        suggestionsCallback: _suggestionsCallback,
        itemBuilder: _itemBuilder,
        onSuggestionSelected: _onSuggestionSelected,
    );
  }
}


