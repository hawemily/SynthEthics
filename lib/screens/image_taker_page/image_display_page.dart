import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Image display page for image taken from the scanner. To be replaced in the
// future with constructing a item profile to be added to the closet.
class ImageDisplayPage extends StatefulWidget {
  final File image;

  ImageDisplayPage({this.image});

  @override
  ImageDisplayPageState createState() => ImageDisplayPageState();
}

class ImageDisplayPageState extends State<ImageDisplayPage> {
  Widget detectedTextWidget = CircularProgressIndicator();

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
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(widget.image);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);
    setState(() {
      detectedTextWidget = _buildDetectedText(visionText);
    });
  }

  String _cleanOriginText(String originMatch) {
    if (originMatch == null) return null;
    return originMatch.split(' ').last;
  }

  String _cleanMaterialText(String materialMatch) {
    if (materialMatch == null) return null;
    return materialMatch.split(' ').last.substring(1);
  }

  Widget _buildDetectedText(VisionText visionText) {
    String material;
    String origin;

    List<Widget> detectedTextBlocks = [
      Image.file(widget.image),
      Text("\n[Detected Text]"),
    ];
    RegExp expSource = RegExp(r"MADE IN (\w+)");
    RegExp expMaterial = RegExp(r"%\s?(\w+)");

    for (int i = 0; i < visionText.blocks.length; i++) {
      String text = visionText.blocks[i].text;
      detectedTextBlocks.add(
          Text(text)
      );

      if (origin == null) {
        RegExpMatch originMatch = expSource.firstMatch(text.toUpperCase());
        if (originMatch != null) {
          origin = originMatch.group(0);
          print("Source ${origin}");
        }
      }
      if (material == null) {
        RegExpMatch materialMatches = expMaterial.firstMatch(text.toUpperCase());
        if (materialMatches != null) {
          material = materialMatches.group(0);
          print("Material ${material}");
        }
      }
    }

    detectedTextBlocks.addAll([
      Text("\n\n[Detected Keywords]"),
      Text("Place of Manufacture: ${_cleanOriginText(origin)}"),
      Text("Material: ${_cleanMaterialText(material)}\n")
    ]);
    return Column(
        children: [
          Flexible(
            child: ListView(
              children: detectedTextBlocks,
            )
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recognised Text'),
      ),
      body: Center(
            child: detectedTextWidget
      ),
    );
  }
}
