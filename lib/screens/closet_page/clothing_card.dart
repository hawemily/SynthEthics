import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/eco_bar.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';

class ClothingCard extends StatefulWidget {
  const ClothingCard(
      {Key key,
      this.clothingItem,
      this.isOutfit = false,
      this.selectItemForOutfit})
      : super(key: key);

  final Function selectItemForOutfit;
  final ClothingItemObject clothingItem;
  final bool isOutfit;

  @override
  ClothingCardState createState() => ClothingCardState();
}

class ClothingCardState<T extends ClothingCard> extends State<T> {

  ClothingItemObject currentClothingItem;
  Future<ClothingItemObject> updatedClothingItem;
  Future<File> currClothingItemImage;
  bool isSelectedOutfit;
  int timesWorn = 0;

  CurrentUser user = CurrentUser.getInstance();

  @override
  void initState() {
    currentClothingItem = widget.clothingItem;
    super.initState();
    currClothingItemImage = getImage();
    isSelectedOutfit = false;
    updatedClothingItem = this.getAClothingItem();
    this.returnTimesWorn();
  }

  Future<File> getImage() {
    return ImageManager.getInstance()
        .loadPictureFromDevice(this.currentClothingItem.id);
  }

  void tapAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ClothingItem(clothingItem: this.currentClothingItem, incrementTimesWorn: returnTimesWorn)));
  }

  Future<ClothingItemObject> getAClothingItem() async {
    final response = await api_client.get("/closet/allClothes/" + this.currentClothingItem.id + "/" + user.getUID());

    if (response.statusCode == 200) {
      
      final resBody = jsonDecode(response.body);
      final clothingItem = ClothingItemObject.fromJson(resBody);

      return clothingItem;
    } else {
      throw Exception("Failed to load clothing item");
    }

  }

  
  void returnTimesWorn() {

    getAClothingItem().then((clothingItem) {
      setState(() {
        this.currentClothingItem = clothingItem;
      });
    });
    
  }

  Widget buildImage() {
    return (isSelectedOutfit == true && isSelectedOutfit != null)
        ? Align(
            alignment: Alignment.center,
            child: Icon(Icons.check, color: CustomColours.accentCopper()))
        : FutureBuilder<File>(
            future: this.currClothingItemImage,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.file(snapshot.data);
              } else if (snapshot.data == null) {
                return Text("No image from file");
              }
              return LinearProgressIndicator();
            });
  }

  Widget getIcon() {
    return GestureDetector(
        onTap: () {
          setState(() {
            this.isSelectedOutfit = !this.isSelectedOutfit;
          });
          widget.selectItemForOutfit(
              this.currentClothingItem.id, this.isSelectedOutfit);
        },
        child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: CustomColours.accentCopper()),
            child: () {
              var icon = Icons.add;
              return Icon(icon, color: CustomColours.offWhite(), size: 10.0);
            }()));
  }

  Widget buildBaseStack(on_tap, {clear = false}) {
    return Stack(children: [
      Card(
          color: CustomColours.offWhite(),
          margin: EdgeInsets.all(5.0),
          child: InkWell(
              onTap: on_tap,
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Stack(children: [
                    buildImage(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: clear
                            ? Container()
                            : EcoBar(
                                current: this.currentClothingItem.data.currentTimesWorn,
                                max: this
                                    .currentClothingItem
                                    .data
                                    .maxNoOfTimesToBeWorn)),
                  ]))))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Stack stack = this.buildBaseStack(this.tapAction);
    if (widget.isOutfit) {
      stack.children.add(Positioned(top: 0.0, right: 0.0, child: getIcon()));
    }
    return stack;
  }
}
