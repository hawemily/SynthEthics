import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:synthetics/routes.dart';
import 'package:synthetics/screens/clothing_colour_page/color_classifier.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/clothing_types/clothing_materials.dart';
import 'package:synthetics/services/colour_fetcher/colour_fetcher.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';
import 'package:synthetics/services/image_taker/image_taker.dart';
import 'package:synthetics/services/string_operator/string_operator.dart';
import 'package:synthetics/theme/custom_colours.dart';

import 'clothing_label_dropdown.dart';


/// Page for user customisation of the item of clothing before adding the item
/// to the user's closet. Including adding a photo for icon, name and brand.
///
/// Item colour category classification occurs here.
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

  /// Determine if save is currently occuring, this is to allow for prevention
  /// of redirection until save is complete
  bool _saveActive() {
    return (_clothingImage != null
        && _clothingName != ""
        && _clothingBrand != null
        && _hasMappedColour);
  }

  /// Save item to closet
  void _saveToCloset() async {
    setState(() {
      _savingInProgress = true;
    });

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
            'materials': [ClothingMaterials.getInstance().materialMapping(widget.clothingMaterial)],
            'clothingType': widget.clothingType,
            'currLocation': widget.location,
            'origin': widget.placeOfOrigin,
            'lastWorn': DateTime.now().toString(),
            'dateOfpurchase': DateTime.now().toString(),
            'dominantColor': OutfitColor.values.indexOf(_mappedColour),
          })
      );

      if (response.statusCode == 200) {
        final clothingId = jsonDecode(response.body)['clothingID'];
        await ImageManager.getInstance().savePictureToDevice(_clothingImage,
                                                             clothingId);

        // Perform a clear stac and push back to the home page
        Navigator.popUntil(
            context,
            ModalRoute.withName(routeMapping[Screens.Home])
        );

        // Ensure that the home page is rebuilt in the event that relevant data
        // has been changed.
        Navigator.pop(context);
        Navigator.pushNamed(context, routeMapping[Screens.Home]);
      }
    } catch (e) {
      print("in add to closet page: $e");
    }
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
                            : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(CustomColours.accentGreen()),)
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
                    }),
                    _WritableCard(label: "Brand", func: (text) {
                      setState(() {
                        _clothingBrand = text;
                      });
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

  /// Callback function to pass to image_taker such that the taken image is
  /// passed back here
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


/// Local widget used for cards with writeable contents
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


/// Local widget used for cards with readonly content
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


/// Local widget for navigation buttons at the top of the page
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
            child: Text(
              this.text,
              style: TextStyle(color:  CustomColours.accentGreen()),),
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

