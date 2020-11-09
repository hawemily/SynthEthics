import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:synthetics/screens/image_taker_page/add_to_closet_page.dart';
import 'package:synthetics/screens/image_taker_page/textfield/autocomplete_textfield.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/clothing_types/clothing_materials.dart';
import 'package:synthetics/services/clothing_types/clothing_types.dart';
import 'package:synthetics/services/country/country_data.dart';
import 'package:synthetics/services/label_parser/label_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:synthetics/services/string_operator/string_operator.dart';

import 'package:synthetics/theme/custom_colours.dart';

import 'clothing_label_dropdown.dart';
import 'carma_detail_display.dart';

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
  bool _updatedCarma = false;
  bool _hasInitialQuery = false;

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
      List<String> clothingTypes = ['None'];
      for (String type in value) {
        clothingTypes.add(StringOperator.capitalise(type));
      }
      setState(() {
        _clothingTypes = clothingTypes;
      });
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

    // TODO: Remove testing variables
    // Testing Variables
    final origin = "MADE IN MYANMAR";
    final material = "%POLYESTER";

    setState(() {
      _placeOfOrigin = StringOperator.capitaliseClear(_cleanOriginText(origin));
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

    int countryIndex = CountryData.containsCountry(countryNames, _placeOfOrigin);
    if (countryIndex == -1) {
      countryNames.insert(0, "");
      countryIndex = 0;
      _placeOfOrigin = "";
    } else {
      _placeOfOrigin = StringOperator.capitaliseClear(_placeOfOrigin);
    }

    setState(() {
      _countryIndex = countryIndex;
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
    } else {
      _clothingMaterial = StringOperator.capitaliseClear(_clothingMaterial);
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

      api_client.post(
        "/carma",
          headers: <String, String>{
            'Content-Type': 'application/json'
          },
          body: jsonEncode(<String, dynamic>{
            'category': _clothingType, // Convert to match backend
            'materials': [_clothingMaterial],
            'currLocation': _positionData,
            'origin': _placeOfOrigin
          }),
      ).then((queryResult) {
        final response = jsonDecode(queryResult.body);
        int carma = 0;
        if (response['carma'] != null) {
          carma = response['carma'];
        }

        print("carma points: $carma");
        setState(() {
          _carmaPoints = carma;
          _loadingCarma = false;
          _updatedCarma = false;
        });
      });

    }
  }

  String _cleanOriginText(String originMatch) {
    if (originMatch == null || originMatch == "") return originMatch;
    return originMatch.split(' ').last;
  }

  String _cleanMaterialText(String materialMatch) {
    if (materialMatch == null || materialMatch == "") return materialMatch;

    return materialMatch.split('%').last.trim();
  }

  bool _canCalculateCarma() {
    return _updatedCarma
        && _completedLoadingData
        && _validData
        && !_loadingCarma;
  }

  Widget _buildDetectedText() {
    print("Building");

    List<Widget> detectedTextBlocks = [
      Container(
        height: 150,
        width: 150,
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
    if (_canCalculateCarma()) {
      if (!_hasInitialQuery) _hasInitialQuery = true;
      _getCarmaPoints();
    }

    print("Country index " + _countryIndex.toString());
    detectedTextBlocks.addAll([
      CarmaPointDetails(
        points: _carmaPoints,
        hasStarted: _hasInitialQuery,
        loading: (!_completedLoadingData || _loadingCarma),
        valid: _validData,
      ),
      // ClothingLabelDropdown(
      //     data: _countryNames,
      //     selected: _countryIndex,
      //     label: 'Country of Origin',
      //     onChange: (value) {
      //       setState(() {
      //         _countryIndex = value;
      //         _placeOfOrigin = _countryNames[value];
      //         _setValidData();
      //         _updatedCarma = true;
      //       });
      //     }),
      AutoTextField(
        data: _countryNames,
        defaultText: _placeOfOrigin,
        label: 'Country of Origin',
        onSelected: (item) {
          setState(() {
            _placeOfOrigin = item;
            _setValidData();
            _updatedCarma = true;
          });
          print("SELECTED $item");
        },
      ),
      ClothingLabelDropdown(
        data: _materialTypes,
        selected: _materialIndex,
        label: 'Material',
        onChange: (value) {
          setState(() {
            _materialIndex = value;
            _clothingMaterial = _materialTypes[value];
            _setValidData();
            _updatedCarma = true;
          });
        }
      ),
      ClothingLabelDropdown(
        data: _clothingTypes,
        selected: _typeIndex,
        label: 'Type',
        onChange: ((value) {
          setState(() {
            _typeIndex = value;
            _clothingType = _clothingTypes[value];
            _validClothingType = value != 0;
            _setValidData();
            _updatedCarma = true;
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
                  onPressed: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddToClosetPage(
                                  placeOfOrigin: _placeOfOrigin,
                                  clothingMaterial: _clothingMaterial,
                                  clothingType: _clothingType,
                                  location: _positionData,
                                  carmaPoints: _carmaPoints,
                                )
                        )
                    );
                  }),
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
        padding: EdgeInsets.only(left :20, right : 20, bottom : 20),
        child: (_completedLoadingPage)
            ? _buildDetectedText()
            : CircularProgressIndicator(),
      )),
    );
  }
}

