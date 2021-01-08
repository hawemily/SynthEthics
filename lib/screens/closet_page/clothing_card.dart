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
      this.isRandom = false,
      this.isDonated = false,
      this.selectItemForOutfit})
      : super(key: key);

  final Function selectItemForOutfit;
  final ClothingItemObject clothingItem;
  final bool isOutfit;
  final bool isRandom;
  final bool isDonated;

  @override
  ClothingCardState createState() => ClothingCardState();
}

class ClothingCardState<T extends ClothingCard> extends State<T> {
  ClothingItemObject currentClothingItem;
  Future<File> currClothingItemImage;
  bool isSelectedOutfit;
  int timesWorn = 0;
  CurrentUser user = CurrentUser.getInstance();

  @override
  void initState() {
    super.initState();
    isSelectedOutfit = false;
    this.returnTimesWorn();
    _init();
  }

  void _init() {
    currentClothingItem = widget.clothingItem;
    print("CurrentClothingItem: ${currentClothingItem.data.name}");
    currClothingItemImage = getImage();
  }

  Future<File> getImage() {
    return ImageManager.getInstance()
        .loadPictureFromDevice(this.currentClothingItem.id);
  }

  void tapAction() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClothingItem(
                clothingItem: this.currentClothingItem,
                getTimesWorn: returnTimesWorn)));
  }

  // refreshes the status of the clothing item to ensure changes made in another widget is reflected in the closet.
  Future<ClothingItemObject> getAClothingItem() async {
    if (this.currentClothingItem == null) return null;
    final response = await api_client.get("/closet/allClothes/" +
        this.currentClothingItem.id +
        "/" +
        user.getUID());

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
        if (clothingItem != null &&
            clothingItem.data != null &&
            clothingItem.data.currentTimesWorn !=
                this.currentClothingItem.data.currentTimesWorn) {
          this.currentClothingItem = clothingItem;
        }
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
              } else if (snapshot.hasError) {
                return Text("No image from file");
              }
              return Container();
              // return LinearProgressIndicator();
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

  bool notNull(Object o) => o != null;

  Widget buildOverlay() {
    if (widget.isDonated) {
      return Container(
          color: Colors.white70,
          child: Center(
              child: Icon(
            Icons.store_mall_directory,
            color: CustomColours.accentGreen(),
          )));
    }
    return null;
  }

  Widget buildBaseStack(on_tap) {
    if (widget.isRandom) _init();
    return Stack(children: [
      Card(
          color: CustomColours.offWhite(),
          margin: EdgeInsets.all(5.0),
          child: InkWell(
              onTap: widget.isDonated ? () {} : on_tap,
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Stack(
                      children: [
                    buildImage(),
                    buildOverlay(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: EcoBar(
                            current:
                                this.currentClothingItem.data.currentTimesWorn,
                            max: this
                                .currentClothingItem
                                .data
                                .maxNoOfTimesToBeWorn)),
                  ].where(notNull).toList()))))
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
