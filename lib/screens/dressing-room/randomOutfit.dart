import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/clothing_card.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:image/image.dart' as ImageOps;
import '../../services/image_taker/image_manager.dart';
import '../clothing_colour_page/color_classifier.dart';
import 'dart:ui' as ui;

import '../clothing_colour_page/color_classifier.dart';
import '../clothing_colour_page/color_classifier.dart';
import '../clothing_colour_page/color_classifier.dart';
import '../clothing_colour_page/color_classifier.dart';
import '../clothing_colour_page/colour_scheme_checker.dart';

class RandomOutfit extends StatefulWidget {
  RandomOutfit(this.clothingItems);

  final Map<String, List<ClothingItemObject>> clothingItems;

  @override
  _RandomOutfitState createState() => _RandomOutfitState();
}

class _RandomOutfitState extends State<RandomOutfit> {
  List<ClothingItemObject> randomItems = [];
  int noOfItems = 2;
  List<OutfitColor> outfitColorsList = [];

  @override
  void initState() {
    super.initState();
    randomItems = generateRandom();
  }

  ImageOps.Image _cropToCenter(ImageOps.Image image, double portion) {
    print("height: ${image.height} width: ${image.width}");
    final int cropHeight = (image.height * portion).round();
    final int cropWidth = (image.width * portion).round();
    final int yStart = ((image.height - cropHeight) / 2).round();
    final int xStart = ((image.width - cropWidth) / 2).round();
    return ImageOps.copyCrop(image, xStart, yStart, cropWidth, cropHeight);
  }

  Future<File> getImage(String id) {
    return ImageManager.getInstance().loadPictureFromDevice(id);
  }

  Future<List<OutfitColor>> getDominantColours(File image) async {
    ImageOps.Image customImage = ImageOps.decodeImage(image.readAsBytesSync());
    customImage = _cropToCenter(customImage, 0.8);

    ui.Codec codec =
        await ui.instantiateImageCodec(ImageOps.encodePng(customImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImage(frameInfo.image);

    final List<PaletteColor> colors = paletteGenerator.paletteColors;
    final List<OutfitColor> res = [];
    for (PaletteColor color in colors) {
      res.add(ColorClassifier().classifyColor(color.color));
    }
    return res;
  }

  List<ClothingItemObject> generateRandom() {
    var clothingItems = widget.clothingItems;
    Random random = new Random();
    clothingItems.forEach((key, value) async {
      var item = value[random.nextInt(value.length)];
      File image = await getImage(item.id);
      List<OutfitColor> temp = await getDominantColours(image);

      if (randomItems.isEmpty) {
        randomItems.add(item);
        outfitColorsList.addAll(temp);
      } else {
        print("--------------------gets here --------------------------");
        var check = [];
        check.addAll(outfitColorsList);
        check.addAll(temp);
        while (!ColourSchemeChecker().isValid(check)) {
          value.remove(item);
          item = value[random.nextInt(value.length)];
          //need to change control flow - only checks for one clash
          image = await getImage(item.id);
          temp = await getDominantColours(image);
          check = [];
          check.addAll(outfitColorsList);
          check.addAll(temp);
        }
        //gets here if valid
        randomItems.add(item);
        outfitColorsList.addAll(temp);
      }
    });
    print("------------------------Generate-----------------------");
    print(randomItems);
    return randomItems;
  }

  void saveOutfit() async {
    print("OUTFIT SELECTED");
    if (randomItems.isEmpty) {
      Navigator.pop(context, "none");
      return;
    }

    var items = [];

    for (var i in randomItems) {
      items.add(i.id);
    }

    print(jsonEncode(<String, dynamic>{'name': "outfitName", 'ids': items}));
    // put in try, loading icon
    await api_client
        .post("/postOutfit",
            body: jsonEncode(
                <String, dynamic>{'name': "outfitName", 'ids': items}))
        .then((e) {
      print("in closet container");
      print(e.statusCode);
      print(e.body);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColours.greenNavy(),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Generate Outfit'),
        ),
        body: ListView(
          children: [
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                for (var item in this.randomItems)
                  () {
                    return ClothingCard(clothingItem: item);
                  }()
              ],
            ),
            Padding(padding: EdgeInsets.all(20)),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              buttonHeight: 20,
              buttonMinWidth: 60,
              children: [
                IconButton(
                  color: CustomColours.greenNavy(),
                  icon: Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                    icon: Icon(Icons.refresh),
                    color: CustomColours.greenNavy(),
                    tooltip: 'Refresh',
                    onPressed: () => {
                          setState(() {
                            this.randomItems = generateRandom();
                          })
                        }),
                IconButton(
                  color: CustomColours.greenNavy(),
                  icon: Icon(Icons.check),
                  tooltip: 'Save',
                  onPressed: () => saveOutfit(),
                ),
              ],
            )
          ],
        ));
  }
}
