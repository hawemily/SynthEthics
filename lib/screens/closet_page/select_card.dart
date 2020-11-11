// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:synthetics/components/eco_bar.dart';
// import 'package:synthetics/screens/item_dashboard/clothing_item.dart';
// import 'package:synthetics/screens/closet_page/clothing_card.dart';
// import 'package:synthetics/theme/custom_colours.dart';
// import 'package:synthetics/responseObjects/clothingItemObject.dart';
// import 'package:synthetics/services/image_taker/image_manager.dart';
//
// class OutfitCard extends ClothingCard {
//   const OutfitCard(
//       {Key key, this.outfitClothingList})
//       : super(key: key);
//
//   final List<ClothingItemObject> outfitClothingList;
//
//   @override
//   _OutfitCardState createState() => _OutfitCardState();
// }
//
// class _OutfitCardState extends ClothingCardState<OutfitCard> {
//
//   _OutfitCardState({this.clothingItem, this.outfitClothingList}) {
//     if (this.outfitClothingList != null) {
//       this.index = 0;
//       this.currentClothingItem = this.outfitClothingList[this.index];
//     } else if (this.clothingItem != null) {
//       this.currentClothingItem = this.clothingItem;
//     } else {
//       this.currentClothingItem = null;
//     }
//   }
//
//   bool clear = false;
//   int index = -1;
//   ClothingItemObject currentClothingItem;
//   final ClothingItemObject clothingItem;
//   final List<ClothingItemObject> outfitClothingList;
//   Future<File> currClothingItemImage;
//
//   @override
//   void initState() {
//     this.index = 0;
//     this.currentClothingItem = this.outfitClothingList[this.index];
//     currClothingItemImage = getImage();
//   }
//
//   Future<File> getImage() {
//     return ImageManager.getInstance().loadPictureFromDevice(
//         this.currentClothingItem.id);
//   }
//
//
//   // Widget getIcon() {
//   //   return GestureDetector(
//   //       onTap: () {
//   //         if (display == ClothingCardDisplay.Outfit) {
//   //           setState(() {
//   //             this.clear = true;
//   //           });
//   //         } else if (display == ClothingCardDisplay.ClosetSelect) {
//   //           print("select");
//   //         }
//   //       },
//   //       child: Container(
//   //           width: 20.0,
//   //           height: 20.0,
//   //           decoration: BoxDecoration(
//   //               borderRadius: BorderRadius.circular(20.0),
//   //               color: CustomColours.accentCopper()),
//   //           child: () {
//   //             var icon = null;
//   //             if (display == ClothingCardDisplay.Outfit) {
//   //               icon = Icons.remove;
//   //             } else {
//   //               icon = Icons.done;
//   //             }
//   //             return Icon(icon, color: CustomColours.offWhite(), size: 10.0);
//   //           }()));
//   // }
//
//   // List<Widget> getLeftRightControls() {
//   //   return <Widget>[
//   //     Positioned(
//   //         top: 75.0,
//   //         left: 15.0,
//   //         child: GestureDetector(
//   //             onTap: () {
//   //               if (index > 0) {
//   //                 setState(() {
//   //                   this.currentClothingItem = this.outfitClothingList[this.index - 1];
//   //                   this.currClothingItemImage = getImage();
//   //                   this.index = this.index - 1;
//   //                 });
//   //               }
//   //             },
//   //             child: this.index == 0
//   //                 ? Container()
//   //                 : Icon(Icons.arrow_back_ios,
//   //                     color: CustomColours.offWhite(), size: 20.0))),
//   //     Positioned(
//   //         top: 75.0,
//   //         right: 10.0,
//   //         child: GestureDetector(
//   //             onTap: () {
//   //               if (index < outfitClothingList.length - 1) {
//   //                 setState(() {
//   //                   this.currentClothingItem = this.outfitClothingList[this.index + 1];
//   //                   this.currClothingItemImage = getImage();
//   //                   this.index = this.index + 1;
//   //                 });
//   //               }
//   //             },
//   //             child: this.index == this.outfitClothingList.length - 1
//   //                 ? Container()
//   //                 : Icon(Icons.arrow_forward_ios,
//   //                     color: CustomColours.offWhite(), size: 20.0)))
//   //   ];
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//         children: (() {
//           var base = <Widget>[
//             Card(
//                 color: CustomColours.offWhite(),
//                 margin: EdgeInsets.all(5.0),
//                 child: InkWell(
//                     onTap: () =>
//                     {
//                       Navigator.push(context, MaterialPageRoute(
//                           builder: (context) =>
//                               ClothingItem(
//                                   clothingItem: this.currentClothingItem)
//                       ))
//                     },
//                     child: Padding(
//                         padding: EdgeInsets.all(5.0),
//                         child: Stack(
//                             children: (() {
//                               var cardChildren = <Widget>[
//                                 FutureBuilder<File>(
//                                     future: this.currClothingItemImage,
//                                     builder: (context, snapshot) {
//                                       if (snapshot.hasData) {
//                                         return Image.file(snapshot.data);
//                                       } else if (snapshot.data == null) {
//                                         return Text("No image from file");
//                                       }
//                                       return LinearProgressIndicator();
//                                     }
//                                 ),
//                                 Align(
//                                     alignment: Alignment.bottomCenter,
//                                     child: EcoBar(current: 20, max: 20)),
//                               ];
//                               return cardChildren;
//                             }())))))
//           ];
//
//           // if (display != ClothingCardDisplay.Closet) {
//           //   base.add(Positioned(top: 0.0, right: 0.0, child: getIcon()));
//           //   if (display == ClothingCardDisplay.Outfit) {
//           //     base.addAll(getLeftRightControls());
//           //   }
//           // }
//           return base;
//         }()));
//   }
// }