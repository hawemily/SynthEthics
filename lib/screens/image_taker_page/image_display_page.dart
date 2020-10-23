import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:synthetics/screens/image_taker_page/add_to_closet_page.dart';
import 'package:synthetics/services/country/country_data.dart';

import 'package:synthetics/theme/custom_colours.dart';

// Image display page for image taken from the scanner. To be replaced in the
// future with constructing a item profile to be added to the closet.
class ImageDisplayPage extends StatefulWidget {
  final File image;

  ImageDisplayPage({this.image});

  @override
  ImageDisplayPageState createState() => ImageDisplayPageState();
}

class ImageDisplayPageState extends State<ImageDisplayPage> {
  Widget _detectedTextWidget = CircularProgressIndicator();
  Widget _carmaDisplay;

  int _carmaPoints = -1;
  int _countryIndex = 0;

  String _placeOfOrigin = "";
  String _clothingMaterial = "";

  void initFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    initFirebase();
    _detectText();
    super.initState();
  }

  void _detectText() async {
    // final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(widget.image);
    // final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    // final VisionText visionText = await textRecognizer.processImage(visionImage);
    final visionText = null;
    _buildDetectedText(visionText).then((result) {
      setState(() {
        _detectedTextWidget = result;
      });
    });
  }

  void _getCarmaPoints() {
    // TODO: Replace with calls to calculator once that is complete
    final carma = Random().nextInt(200);
    print("gained $carma points");
    print("carma points: ${_carmaPoints + carma}");

    setState(() {
      _carmaPoints = _carmaPoints += carma;
      _carmaDisplay = _CarmaPointDetails(points: _carmaPoints);
    });
  }

  bool _match(String origin, List data) {
    bool foundMatch = false;
    for (int i = 0; i < data.length; i++) {
      print(data[i]);
      if (origin.toUpperCase() == data[i]['country'].toUpperCase()) {
        foundMatch = true;
        setState(() {
          _countryIndex = i;
        });
      }
    }
    return foundMatch;
  }

  String _cleanOriginText(String originMatch) {
    if (originMatch == null) return null;
    return originMatch.split(' ').last;
  }

  String _cleanMaterialText(String materialMatch) {
    if (materialMatch == null) return null;
    return materialMatch.split(' ').last.substring(1);
  }

  Future<Widget> _buildDetectedText(VisionText visionText) async {
    String material;
    String origin;

    List<Widget> detectedTextBlocks = [
      Container(
        height: 250,
        width: 250,
        margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(widget.image),
            )),
      ),
    ];
    // RegExp expSource = RegExp(r"MADE IN (\w+)");
    // RegExp expMaterial = RegExp(r"%\s?(\w+)");
    //
    // for (int i = 0; i < visionText.blocks.length; i++) {
    //   String text = visionText.blocks[i].text;
    //
    //   if (origin == null) {
    //     RegExpMatch originMatch = expSource.firstMatch(text.toUpperCase());
    //     if (originMatch != null) {
    //       origin = originMatch.group(0);
    //       print("Source ${origin}");
    //     }
    //   }
    //   if (material == null) {
    //     RegExpMatch materialMatches = expMaterial.firstMatch(text.toUpperCase());
    //     if (materialMatches != null) {
    //       material = materialMatches.group(0);
    //       print("Material ${material}");
    //     }
    //   }
    // }

    // String preMatchOrigin = _cleanOriginText(origin);
    // TODO: Remove placeholder once deployed
    String preMatchOrigin = "MYANMA";
    //

    final countryData = await CountryData.getInstance().countryData;
    List countryNames = countryData.map((e) {
      return e['country'];
    }).toList();
    print(countryNames);

    bool hasMatch = _match(preMatchOrigin, countryData);
    if (!hasMatch) {
      countryNames.insert(0, preMatchOrigin);
    }

    setState(() {
      _placeOfOrigin = preMatchOrigin;
      //   _clothingMaterial = _cleanMaterialText(material);

      // TODO: Remove placeholder once deployed
      _clothingMaterial = "POLYESTER";
      //
    });

    _getCarmaPoints();

    detectedTextBlocks.addAll([
      _carmaDisplay,
      _ClothingLabelDropdown(
          data: countryNames,
          selected: _countryIndex,
          onChange: (value) {
            setState(() {
              _countryIndex = value - ((hasMatch) ? 0 : 1);
            });
            print(_countryIndex);
          }),
      _ClothingLabelDetail(
          text: _clothingMaterial,
          label: "Material",
          getPoints: (s) {
            setState(() {
              _clothingMaterial = s;
            });
            _getCarmaPoints();
            setState(() {
              _carmaDisplay = Container();
            });
            print(_carmaDisplay);
          }),
      ((_carmaPoints >= 0)
          ? Container(
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => CustomColours.iconGreen()),
                      padding: MaterialStateProperty.resolveWith((states) =>
                          EdgeInsets.only(
                              top: 15, bottom: 15, left: 20, right: 20))),
                  child: Text("Add to Closet",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddToClosetPage(
                                  placeOfOrigin: _placeOfOrigin,
                                  clothingMaterial: _clothingMaterial,
                                  carmaPoints: _carmaPoints,
                                )));
                  },
                ),
              ),
            )
          : Container())
    ]);

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Flexible(
          child: ListView(
        children: detectedTextBlocks,
      ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recognised Text'),
        backgroundColor: CustomColours.greenNavy(),
      ),
      body: Center(
          child: Container(
              padding: EdgeInsets.all(20), child: _detectedTextWidget)),
    );
  }
}

class _ClothingLabelDropdown extends StatefulWidget {
  final data;
  final selected;
  final Function onChange;

  _ClothingLabelDropdown({this.data, this.selected, this.onChange});

  @override
  _ClothingLabelDropdownState createState() => _ClothingLabelDropdownState();
}

class _ClothingLabelDropdownState extends State<_ClothingLabelDropdown> {
  var _value;

  @override
  void initState() {
    _value = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> dropDownMenuItems = [];
    for (var entry in widget.data) {
      dropDownMenuItems.add(DropdownMenuItem(
        child: Text(entry),
        value: widget.data.indexOf(entry),
      ));
    }
    print(dropDownMenuItems);
    return Card(
      child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: DropdownButton(
            isExpanded: true,
            value: _value,
            items: dropDownMenuItems,
            onChanged: ((value) {
              setState(() {
                _value = value;
              });
              widget.onChange(value);
            }),
          )),
    );
  }
}

class _ClothingLabelDetail extends StatefulWidget {
  final text;
  final label;
  final getPoints;

  _ClothingLabelDetail({this.text, this.label, this.getPoints});

  @override
  _ClothingLabelDetailState createState() => _ClothingLabelDetailState();
}

class _ClothingLabelDetailState extends State<_ClothingLabelDetail> {
  var text;
  String labelText;

  @override
  void initState() {
    this.labelText = "${widget.label}: ${widget.text}";
    this.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Center(
                // child: Text(this.label + " " + this.text)
                child: TextField(
              onSubmitted: (text) {
                if (text != "") {
                  setState(() {
                    this.text = text.toUpperCase();
                    this.labelText = "${widget.label}";
                  });
                  widget.getPoints(this.text);
                } else {
                  setState(() {
                    this.labelText = "${widget.label}: ${this.text}";
                  });
                }
              },
              decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none,
                hintText: "$text",
                // labelText: "${widget.label}: $text",
              ),
            ))));
  }
}


class _CarmaPointDetails extends StatefulWidget {
  final points;
  _CarmaPointDetails({this.points});

  @override
  _CarmaPointDetailsState createState() => _CarmaPointDetailsState();
}

class _CarmaPointDetailsState extends State<_CarmaPointDetails> {
  Color carmaWidgetColour;
  String carmaText;

  @override
  void initState() {
    _getCarmaInfo();
    super.initState();
  }

  void _getCarmaInfo() {
    if (widget.points > 0) {
      // Have some carma points
      carmaWidgetColour = CustomColours.iconGreen();
      carmaText = "${widget.points} Carma Points!";
    } else {
      // Display failed
      carmaWidgetColour = Colors.red;
      carmaText = "Oops. We can't seem to get accurate readings, is the information below correct?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Text(carmaText, style: TextStyle(color: Colors.white))
          ),
        ),
      color: carmaWidgetColour,
    );
  }
}

