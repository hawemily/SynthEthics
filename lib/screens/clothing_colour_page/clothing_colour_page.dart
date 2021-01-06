import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:synthetics/screens/clothing_colour_page/color_classifier.dart';
import 'package:synthetics/services/image_taker/image_taker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:image/image.dart' as ImageOps;


///
/// Page previously created for image dominant colour display, left in the
/// system for users to use.
///
class ClothingColourPage extends StatefulWidget {
  @override
  _ClothingColourPageState createState() => _ClothingColourPageState();
}

class _ClothingColourPageState extends State<ClothingColourPage> {
  Widget _colorContainer = Container();
  Widget _displayImage = Container();
  Widget _dominantColour = Container();
  
  ImageOps.Image _cropToCenter(ImageOps.Image image, double portion) {
    print("height: ${image.height} width: ${image.width}");
    final int cropHeight = (image.height * portion).round();
    final int cropWidth = (image.width * portion).round();
    final int yStart = ((image.height - cropHeight) / 2).round();
    final int xStart = ((image.width - cropWidth) / 2).round();
    return ImageOps.copyCrop(image, xStart, yStart, cropWidth, cropHeight);
  }

  Future<void> fetchDominantColours(File fileImage) async {

    ImageOps.Image customImage = ImageOps.decodeImage(fileImage.readAsBytesSync());
    customImage = _cropToCenter(customImage, 0.8);

    ui.Codec codec = await ui.instantiateImageCodec(ImageOps.encodePng(customImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImage(frameInfo.image);

    List<Widget> colourDisplays = [];

    final List<PaletteColor> colors = paletteGenerator.paletteColors;

    // Use this list for colours not the above
    List<Color> colorsList = [];
    print("Num colours: ${colors.length}");

    for (PaletteColor color in colors) {
      print("color: ${color.color}");
      print("body text colour: ${color.bodyTextColor}");
      print("population: ${color.population}");
      print("title text color: ${color.titleTextColor}");
      print("");
      colorsList.add(color.color);
      colourDisplays.add(Container(
        height: 40,
        width: 40,
        color: color.color,
      ));
    }

    final dominant = paletteGenerator.dominantColor.color;
    print("RGB ${dominant.red}, ${dominant.green}, ${dominant.blue}");
    print("${ColorClassifier().classifyColor(paletteGenerator.dominantColor.color)}");

    setState(() {
      _displayImage = Container(
        height: 400,
        width: 300,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: FileImage(fileImage)
          )
        ),
      );
      _colorContainer = Container(
        padding: EdgeInsets.all(8),
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: colourDisplays,
        ),
      );
      _dominantColour = Container(
          height: 100,
          width: 100,
          margin: EdgeInsets.all(10),
          color: paletteGenerator.dominantColor.color,
      );
    });

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(fileImage);
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    for (ImageLabel label in labels) {
      String text = label.text;
      String entityId = label.entityId;
      double confidence = label.confidence;
      print("text: $text\nentity: $entityId\nconfidence: $confidence");
    }

    // Release resources allocated to labeler once unneeded
    labeler.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Colour Room"),
        backgroundColor: CustomColours.greenNavy(),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _displayImage,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(),
                  color: CustomColours.greenNavy(),
                ),
                child: IconButton(
                    icon: Icon(Icons.camera, color: CustomColours.offWhite(),),
                    onPressed: () => ImageTaker.settingModalBottomSheet(context,
                        (Future<File> fileFuture) {
                          fileFuture.then((file) async {
                            if (file != null) {
                              // List<int> imageBytes = await file.readAsBytes();
                              // print(imageBytes);
                              // await fetchDominantColours(base64Encode(imageBytes));
                              await fetchDominantColours(file);
                            }
                          });
                        })),
              ),
              _colorContainer,
              _dominantColour
            ],
          )
        )
      ),
    );
  }
}
