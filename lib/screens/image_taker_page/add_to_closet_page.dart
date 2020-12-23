import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:synthetics/routes.dart';
import 'package:synthetics/screens/clothing_colour_page/color_classifier.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/colour_fetcher/colour_fetcher.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';
import 'package:synthetics/services/image_taker/image_taker.dart';
import 'package:synthetics/services/string_operator/string_operator.dart';
import 'package:synthetics/theme/custom_colours.dart';

import 'clothing_label_dropdown.dart';


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
  CurrentUser user = CurrentUser.getInstance();

  OutfitColor _mappedColour;

  File _clothingImage;

  bool _savingInProgress = false;
  bool _hasMappedColour = false;

  bool _saveActive() {
    return (_clothingImage != null
        && _clothingName != ""
        && _clothingBrand != null
        && _hasMappedColour);
  }

  void _saveToCloset() async {
    setState(() {
      _savingInProgress = true;
    });

    print('Save to closet');
    print(DateTime.now().toString());

    print({
          'name': _clothingName,
          'brand': _clothingBrand,
          'materials': [widget.clothingMaterial.toLowerCase()],
          'clothingType': widget.clothingType,
          'currLocation': widget.location,
          'origin': widget.placeOfOrigin,
          'lastWorn': DateTime.now().toString(),
          'dateOfPurchase': DateTime.now().toString(),
          'mappedColour': OutfitColor.values.indexOf(_mappedColour),
        }.toString());

    try {
      final response = await api_client.post(
          "/closet/addItem",
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'uid': user.getUID(),
            'name': _clothingName,
            'brand': _clothingBrand,
            'materials': [widget.clothingMaterial.toLowerCase()],
            'clothingType': widget.clothingType,
            'currLocation': widget.location,
            'origin': widget.placeOfOrigin,
            'lastWorn': DateTime.now().toString(),
            'dateOfpurchase': DateTime.now().toString(),
            'dominantColor': OutfitColor.values.indexOf(_mappedColour),
          })
      );

      print("response $response");
      if (response.statusCode == 200) {
        print("response body ${response.body}");
        print("response Decode ${jsonDecode(response.body)}");
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
      }

    } catch (e) {
      print("in add to closet page: $e");
    }

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
                        ((!_savingInProgress)
                            ? _ATCButtons(
                                text: "Save",
                                func: _saveToCloset,
                                active: _saveActive(),
                              )
                            : CircularProgressIndicator()
                        )
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
                    Container(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: ClothingLabelDropdown(
                        data: OutfitColor.values.map((e) {
                          return StringOperator.enumTrim(e.toString());
                        }).toList(),
                        selected: (_hasMappedColour)
                          ? _mappedColour.index
                          : 1,
                        label: (_hasMappedColour)
                            ? "Colour Category"
                            : "Select an image to see colour category",
                        onChange: ((_hasMappedColour)
                          ? (index) {
                            setState(() {
                              _mappedColour = OutfitColor.values[index];
                            });
                          }
                          : null),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }

  void _imageGetterCallback(Future<File> futureFile) {
    futureFile.then((image) {
      if (image != null) {
        ColourFetcher.fetchDominantColour(image).then((dominantColor) {
          setState(() {
            _clothingImage = image;
            _mappedColour = ColorClassifier().classifyColor(dominantColor);
            _hasMappedColour = true;
          });
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
  final Function func;
  final String text;
  final bool active;
  _ATCButtons({this.text, this.func, this.active: true});

  @override
  Widget build(BuildContext context) {
    if (this.active) {
      return Container(
          child: FlatButton(
            onPressed: this.func,
            child: Text(this.text),
          )
      );
    } else {
      return Container(
          child: FlatButton(
            child: Text(this.text),
            disabledTextColor: Colors.grey,
          )
      );
    }
  }
}

