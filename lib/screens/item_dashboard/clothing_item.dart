import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/closet_page/closet_page.dart';
import 'package:synthetics/screens/item_dashboard/widgets/info_block.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/services/string_operator/string_operator.dart';

/// Class for item dashboard to display stats for each clothing item
/// Allows wear and donate functionality
class ClothingItem extends StatefulWidget {
  ClothingItem({Key key, this.clothingItem, this.getTimesWorn})
      : super(key: key);

  final clothingItem;
  final Function getTimesWorn;

  @override
  _ClothingItemState createState() => _ClothingItemState();
}

class _ClothingItemState extends State<ClothingItem> {
  ClothingItemObject clothingID;
  CurrentUser user = CurrentUser.getInstance();
  var progress;
  int timesWorn;
  double carma;
  File image;
  String lastWorn;

  @override
  void initState() {
    super.initState();
    this.clothingID = widget.clothingItem;
    ImageManager.getInstance()
        .loadPictureFromDevice(this.clothingID.id)
        .then((value) {
      setState(() {
        image = value;
      });
    });

    this.timesWorn = this.clothingID.data.currentTimesWorn.round();
    this.lastWorn = clothingID.data.lastWornDate;
    this.progress = this.timesWorn / this.clothingID.data.maxNoOfTimesToBeWorn;
    this.carma = (this.timesWorn *
        (this.clothingID.data.cF / this.clothingID.data.maxNoOfTimesToBeWorn));
  }

  /// Function to update progress bar depending on how many times item is worn
  void updateProgress(String action) async {
    var amount =
        (this.clothingID.data.cF / this.clothingID.data.maxNoOfTimesToBeWorn);

    bool validAction = false;
    setState(() {
      if (action == 'INC') {
        this.timesWorn++;
        this.carma += amount;
        this.lastWorn = DateTime.now().toString();
        validAction = true;
      } else {
        if (this.timesWorn > 0) {
          this.timesWorn--;
          this.carma -= amount;
          validAction = true;
        }
      }
      this.progress =
          this.timesWorn / this.clothingID.data.maxNoOfTimesToBeWorn;
    });

    if (validAction) {
      await api_client.post("/closet/updateItem",
          body: jsonEncode(<String, dynamic>{
            'uid': user.getUID(),
            'clothingId': this.clothingID.id,
            'timesWorn': this.timesWorn,
            'lastWorn': DateTime.now().toString(),
            'carmaGain': amount,
            'action': action
          }));
    }

    /// Users are alerted that have fulfiled their quuto of wearing the item.
    /// Their 'carma debt' is paid.
    if (this.timesWorn == this.clothingID.data.maxNoOfTimesToBeWorn &&
        this.timesWorn != 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(
                  "Congratulations!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'lib/assets/leaf.jpg',
                      width: 80,
                      height: 80,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10)),
                    Text(
                      "You have used this piece of clothing sustainably!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.75,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ));
          });
    }
    widget.getTimesWorn();
  }

  String customFormatDateTime(String string) {
    DateTime datetime = DateTime.parse(string);
    return DateFormat('dd MMM yy').format(datetime);
  }

  /// Calls backend post function to move the item from user's 'Closet' doc to
  /// 'To be Donated' doc to mark it for donation.
  void donateItem() {
    api_client.post("/markForDonation",
        body: jsonEncode(<String, dynamic>{
          'uid': user.getUID(),
          'ids': [this.clothingID.id]
        }));
    Navigator.push(context, MaterialPageRoute(builder: (context) => Closet()));
  }

  void showConfirmationDialog(BuildContext context) {
    Widget confirmButton = FlatButton(
        child: Text(
          "OK",
          style: TextStyle(fontSize: 18, color: CustomColours.greenNavy()),
        ),
        onPressed: () => donateItem());

    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you want to donate item?"),
      content: Text(
        "This item will no longer be in your closet and all outfits with this item will be removed from dressing room.",
        textAlign: TextAlign.justify,
      ),
      actions: [
        confirmButton,
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColours.greenNavy(),
        appBar: AppBar(
          backgroundColor: CustomColours.greenNavy(),
          iconTheme: IconThemeData(color: Colors.white),
          title:
              Text(clothingID.data.name, style: TextStyle(color: Colors.white)),
        ),
        body: ListView(
          children: <Widget>[
            Container(
                color: CustomColours.offWhite(),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: SizedBox(
                      height: 170.0,
                      child: Stack(
                        children: <Widget>[
                          Center(
                              child: Image.asset(
                            'lib/assets/closet_IT.jpg',
                            width: double.maxFinite,
                            height: 160.0,
                          )),
                          Center(
                            child: Container(
                              width: 170,
                              height: 170,
                              child: new CircularProgressIndicator(
                                strokeWidth: 30,
                                value: progress,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColours.iconGreen()),
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: ((this.image == null)
                                            // TODO: Find a better placeholder image later
                                            ? new NetworkImage(
                                                "https://cdn.endource.com/image/s3-49f2938a8e4d8f6c74bccbd2bf800c06/detail/and-other-stories-ribbed-square-neck-crop-top.jpg")
                                            : FileImage(this.image))))),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        buttonHeight: 20,
                        buttonMinWidth: 60,
                        children: [
                          FlatButton(
                            textColor: CustomColours.greenNavy(),
                            shape: CircleBorder(),
                            child: Text(
                              "Wear",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => updateProgress('INC'),
                          ),
                          IconButton(
                            icon: Icon(Icons.undo),
                            color: CustomColours.greenNavy(),
                            tooltip: 'Undo',
                            onPressed: () => updateProgress('DEC'),
                          ),
                          FlatButton(
                            textColor: CustomColours.greenNavy(),
                            child: Text(
                              "Donate",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => showConfirmationDialog(context),
                          ),
                        ],
                      )),
                ])),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: Color(0xFFB7B7B7).withOpacity(.16),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InfoBlock(
                            color: Colors.deepOrange[600],
                            value: StringOperator.capitalise(
                                clothingID.data.brand),
                            label: "Brand",
                          ),
                          InfoBlock(
                            color: CustomColours.iconGreen(),
                            value: StringOperator.capitalise(
                                clothingID.data.materials[0]),
                            label: "Material",
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: Color(0xFFB7B7B7).withOpacity(.16),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InfoBlock(
                            color: CustomColours.baseBlack(),
                            value:
                                "${this.timesWorn} / ${this.clothingID.data.maxNoOfTimesToBeWorn.round()}",
                            label: "Times Worn",
                          ),
                          InfoBlock(
                            color: CustomColours.negativeRed(),
                            value:
                                "${this.carma.round()} / ${this.clothingID.data.cF.round()}",
                            label: "Carma Pts",
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: Color(0xFFB7B7B7).withOpacity(.16),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InfoBlock(
                            color: Colors.red[900],
                            value: customFormatDateTime(
                                clothingID.data.purchaseDate),
                            label: "Purchased",
                          ),
                          InfoBlock(
                            color: Colors.blue[900],
                            value: customFormatDateTime(
                                clothingID.data.lastWornDate),
                            label: "Last Worn",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: NavBar(selected: 1));
  }
}
