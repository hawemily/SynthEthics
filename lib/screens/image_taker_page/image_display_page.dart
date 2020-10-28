import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:synthetics/screens/image_taker_page/add_to_closet_page.dart';
import 'package:synthetics/services/clothing_types/clothing_materials.dart';
import 'package:synthetics/services/clothing_types/clothing_types.dart';
import 'package:synthetics/services/country/country_data.dart';
import 'package:synthetics/services/label_parser/label_parser.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

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
  int _carmaPoints = -1;
  int _countryIndex = 0;
  int _materialIndex = 0;
  int _typeIndex = 0;

  String _placeOfOrigin = "";
  String _clothingMaterial = "";
  String _clothingType = "";

  List<String> _countryNames = [];
  List<String> _materialTypes = [];
  List<String> _clothingTypes = [];
  List<Map<String, dynamic>> _countryData;

  Map<String, dynamic> _positionData;

  bool _validData = false;
  bool _completedLoadingPage = false;
  bool _completedLoadingData = false;
  bool _loadingCarma = false;
  bool _validClothingType = false;

  void initFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    initFirebase();
    _getClothingData();
    _getUserPosition();
    _detectText();
    super.initState();
  }

  void _getClothingData() async {
    ClothingMaterials.getInstance().types.then((value) {
      setState(() {
        _materialTypes = List.of(value);
      });
    });
    ClothingTypes.getInstance().types.then((value) {
      setState(() {
        _clothingTypes = List.of(value);
      });
      _clothingTypes.insert(0, "None");
    });
  }

  void _getUserPosition() async {
    Position position = await Geolocator.getLastKnownPosition();
    if (position == null) {
      position = await Geolocator.getCurrentPosition();
    }
     setState(() {
       _positionData = {
         'latitude': position.latitude,
         'longitude': position.longitude,
       };
    });
  }

  void _detectText() async {
    // final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(widget.image);
    // final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    // final VisionText visionText = await textRecognizer.processImage(visionImage);
    //
    // // Parse using regex parser with VisionText as label source
    // var labelParser = RegexLabelParser(VisionTextLabelSource(visionText));
    // var labelProperties = labelParser.parseLabel();
    // var origin = labelProperties["origin"];
    // var material = labelProperties["material"];

    final origin = "MADE IN MYANMA";
    final material = "%POLYESTE";

    setState(() {
      _placeOfOrigin = _cleanOriginText(origin);
      _clothingMaterial = _cleanMaterialText(material);
      _completedLoadingPage = true;
    });

    _countryData = await CountryData.getInstance().countryData;
    _validateCountryData();
    _validateMaterialData();
    _setValidData();
  }

  void _setValidData() {
    _validData = (_clothingMaterial != ""
        && _placeOfOrigin != ""
        && _validClothingType
    );
  }

  void _validateCountryData() {
    List<String> countryNames = _countryData.map((e) {
      return e['country'] as String;
    }).toList();

    int matchIndex = CountryData.containsCountry(countryNames, _placeOfOrigin);
    if (matchIndex == -1) {
      countryNames.insert(0, "");
      matchIndex = 0;
      _placeOfOrigin = "";
    }

    setState(() {
      _countryIndex = matchIndex;
      _countryNames = countryNames;
    });
  }

  void _validateMaterialData() {
    int materialIndex =
          ClothingMaterials.getInstance().containsMaterial(_materialTypes,
                                                       _clothingMaterial);
    if (materialIndex == -1) {
      _materialTypes.insert(0, "");
      materialIndex = 0;
      _clothingMaterial = "";
    }

    setState(() {
      _materialIndex = materialIndex;
      _completedLoadingData = true;
    });
  }

  void _getCarmaPoints() async {
    _loadingCarma = true;
    if (_validData) {
      print("position $_positionData");

      // TODO: Replace with calls to calculator once that is complete
      final carma = Random().nextInt(200);
      print("gained $carma points");
      print("carma points: ${_carmaPoints + carma}");

      setState(() {
        _carmaPoints = _carmaPoints += carma;
      });


        // http.post(
        //   "http://10.0.2.2:5001/cfcalc/us-central1/api/carma",
        //   //   "https://us-central1-cfcalc.cloudfunctions.net/api/carma",
        //     headers: <String, String>{
        //       'Content-Type': 'application/json'
        //     },
        //     body: jsonEncode(<String, dynamic>{
        //       'category': 'tops',
        //       'materials': [_clothingMaterial],
        //       'currLocation': position,
        //       'origin': _placeOfOrigin
        //     }
        //     ),
        // ).then((queryResult) => print(queryResult.body));

    }
    _loadingCarma = false;
  }

  String _cleanOriginText(String originMatch) {
    if (originMatch == null || originMatch == "") return originMatch;
    return originMatch.split(' ').last;
  }

  String _cleanMaterialText(String materialMatch) {
    if (materialMatch == null || materialMatch == "") return materialMatch;

    return materialMatch.split('%').last.trim();
  }

  Widget _buildDetectedText() {
    print("Building");

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

    // Avoid making unnecessary backend calls
    if (_completedLoadingData && _validData && !_loadingCarma) {
      _getCarmaPoints();
    }

    print("Country index " + _countryIndex.toString());
    detectedTextBlocks.addAll([
      _CarmaPointDetails(
        points: _carmaPoints,
        loading: (!_completedLoadingData || _loadingCarma),
        valid: _validData,
      ),
      _ClothingLabelDropdown(
          data: _countryNames,
          selected: _countryIndex,
          label: 'Country of Origin',
          onChange: (value) {
            setState(() {
              _countryIndex = value;
              _placeOfOrigin = _countryNames[value];
              _setValidData();
            });
          }),
      _ClothingLabelDropdown(
        data: _materialTypes,
        selected: _materialIndex,
        label: 'Material',
        onChange: (value) {
          setState(() {
            _materialIndex = value;
            _clothingMaterial = _materialTypes[value];
            _setValidData();
          });
        }
      ),
      _ClothingLabelDropdown(
        data: _clothingTypes,
        selected: _typeIndex,
        label: 'Type',
        onChange: ((value) {
          setState(() {
            _typeIndex = value;
            _clothingType = _clothingTypes[value];
            _validClothingType = value != 0;
            _setValidData();
          });
        }),
      ),
      ((_carmaPoints >= 0 && _validData)
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
                                  clothingType: _clothingType,
                                  carmaPoints: _carmaPoints,
                                )
                        )
                    );
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
        padding: EdgeInsets.only(left :20, right : 20),
        child: (_completedLoadingPage)
            ? _buildDetectedText()
            : CircularProgressIndicator(),
      )),
    );
  }
}

class _ClothingLabelDropdown extends StatefulWidget {
  final data;
  final selected;
  final label;
  final Function onChange;

  _ClothingLabelDropdown({this.data, this.selected, this.label, this.onChange});

  @override
  _ClothingLabelDropdownState createState() => _ClothingLabelDropdownState();
}

class _ClothingLabelDropdownState extends State<_ClothingLabelDropdown> {

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
            left: 20,
            right: 20,
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: widget.label,
              enabledBorder: InputBorder.none
            ),
            isExpanded: true,
            value: widget.selected,
            items: dropDownMenuItems,
            onChanged: ((value) {
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
              )
            )
        )
    );
  }
}

class _CarmaPointDetails extends StatefulWidget {
  final int points;
  final bool loading;
  final bool valid;

  _CarmaPointDetails({this.points, this.loading, this.valid});

  @override
  _CarmaPointDetailsState createState() => _CarmaPointDetailsState();
}

class _CarmaPointDetailsState extends State<_CarmaPointDetails> {
  Color carmaWidgetColour;
  String carmaText;

  void _getCarmaInfo() {
    if (widget.valid && widget.points > 0) {
      // Have some carma points
      setState(() {
        carmaWidgetColour = CustomColours.iconGreen();
        carmaText = "${widget.points} Carma Points!";
      });
    } else {
      // Display failed
      setState(() {
        carmaWidgetColour = Colors.red;
        carmaText =
            "Oops. We can't seem to get accurate readings, is the information below correct?";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.loading) {
      _getCarmaInfo();
      return Card(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Text(carmaText, style: TextStyle(color: Colors.white))),
        ),
        color: carmaWidgetColour,
      );
    } else {
      return Card(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator())));
    }
  }
}
