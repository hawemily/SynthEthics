import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synthetics/routes.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';
import 'package:synthetics/services/image_taker/image_taker.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:http/http.dart' as http;


class AddToClosetPage extends StatefulWidget {
  final String placeOfOrigin;
  final String clothingMaterial;
  final String clothingType;

  final int carmaPoints;

  final Map<String, dynamic> location;

  AddToClosetPage({
    this.placeOfOrigin,
    this.clothingMaterial,
    this.clothingType,
    this.carmaPoints,
    this.location,
  });

  @override
  _AddToClosetPageState createState() => _AddToClosetPageState();
}

class _AddToClosetPageState extends State<AddToClosetPage> {
  String _clothingName = "";
  String _clothingBrand = "";

  File _clothingImage;

  void _saveToCloset() async {
    print('Save to closet');
    print(DateTime.now().toString());

    print({
          'name': _clothingName,
          'brand': _clothingBrand,
          'materials': [widget.clothingMaterial.toLowerCase()],
          'clothingType': widget.clothingType,
          'currLocation': widget.location,
          'origin': widget.placeOfOrigin,
          'lastWornDate': DateTime.now().toString(),
          'purchaseDate': DateTime.now().toString(),
        }.toString());

    final response = await http.post(
      // TODO: Replace with closet server when finished
      "http://10.0.2.2:5001/cfcalc/us-central1/api/closet/addItem",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': _clothingName,
        'brand': _clothingBrand,
        'materials': [widget.clothingMaterial.toLowerCase()],
        'clothingType': widget.clothingType,
        'currLocation': widget.location,
        'origin': widget.placeOfOrigin,
        'lastWornDate': DateTime.now().toString(),
        'purchaseDate': DateTime.now().toString(),
      })
    );
    print("response $response");
    if (response != null) {
      print("response body ${response.body}");
      print("response Decode ${jsonDecode(response.body)}");
    }
    final clothingId = jsonDecode(response.body)['clothingID'];
    print("clothingID $clothingId");
    File newImage = await ImageManager.getInstance()
        .savePictureToDevice(_clothingImage, clothingId);
    print(newImage == null);
    if (newImage != null) {
      print(newImage.path);
    }
    Navigator.popUntil(
        context,
        ModalRoute.withName(routeMapping[Screens.Home])
    );
    // TODO: Replace with closet page once the constructor is fixed
    // Navigator.pushNamed(context, routeMapping[Screens.Empty]);
  }

  @override
  Widget build(BuildContext context) {
    Widget carmaDisplay = Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: Card(
          child: Container(
              padding: EdgeInsets.only(
                  top: 20, bottom: 20, left: 20, right: 20),
              child: Text("${widget.carmaPoints} Carma points!",
                style: TextStyle(color: Colors.white),)
          ),
          color: CustomColours.iconGreen(),
        ),
      ),
    );

    // Build clothing image view depending on whether an image has been provided
    Widget clothingImageWidget;
    if (_clothingImage == null)
      clothingImageWidget = Text("+");
    else {
      clothingImageWidget = Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(_clothingImage),
            )
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            title: Text('Add To Closet'),
            backgroundColor: CustomColours.greenNavy(),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Center(
                child: ListView(
                  children: [
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ATCButtons(text: "Back", func: () {
                          Navigator.pop(context);
                        }),
                        _ATCButtons(text: "Save", func: _saveToCloset)
                      ],
                    ),
                    Container(
                      child: OutlinedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith((states) =>
                                CircleBorder()),
                            minimumSize: MaterialStateProperty.resolveWith((
                                states) =>
                                Size.fromHeight(150)),
                            backgroundColor: MaterialStateProperty.resolveWith((
                                states) =>
                                CustomColours.offWhite())
                        ),
                        child: clothingImageWidget,
                        onPressed: () => ImageTaker.settingModalBottomSheet(
                            context, _imageGetterCallback
                        ),
                      ),
                    ),
                    carmaDisplay,
                    _WritableCard(label: "Name", func: (text) {
                      setState(() {
                        _clothingName = text;
                      });
                      print("clothingName: $_clothingName");
                    }),
                    _WritableCard(label: "Brand", func: (text) {
                      setState(() {
                        _clothingBrand = text;
                      });
                      print("clothingBrand: $_clothingBrand");
                    }),
                    _ReadOnlyCards(
                        text: "Material: ${widget.clothingMaterial}"),
                    _ReadOnlyCards(text: "Origin: ${widget.placeOfOrigin}"),
                    _ReadOnlyCards(text: "Type: ${widget.clothingType}"),
                  ],
                )
            )
        )
    );
  }

  void _imageGetterCallback(Future<File> futureFile) {
    futureFile.then((value) {
      if (value != null) {
        setState(() {
          _clothingImage = value;
        });
      }
    });
  }
}


class _WritableCard extends StatefulWidget {
  final label;
  final func;
  _WritableCard({this.label, this.func});

  @override
  _WritableCardState createState() => _WritableCardState();
}

class _WritableCardState extends State<_WritableCard> {
  String text = "";
  String labelText;

  @override
  void initState() {
    setState(() {
      labelText = "${widget.label}: ";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Card(
          child: Container(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
              ),
              child: TextField(
                decoration: InputDecoration(
                    labelText: labelText,
                    border: InputBorder.none,
                    hintText: "$text"
                ),
                onSubmitted: (text) {
                  widget.func(text);
                },
              )
          )
      ),
    );
  }
}


class _ReadOnlyCards extends StatelessWidget {
  final text;
  _ReadOnlyCards({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Card(
          child: Container(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                  bottom: 10
              ),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration.collapsed(
                    hintText: "${this.text}"
                ),
              )
          )
      ),
    );
  }
}

class _ATCButtons extends StatelessWidget {
  final func;
  final text;
  _ATCButtons({this.text, this.func});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
          onPressed: this.func,
          child: Text(this.text)
      )
    );
  }
}

