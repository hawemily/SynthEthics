import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/item_dashboard/widgets/info_block.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/services/current_user.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'package:synthetics/services/string_operator/string_operator.dart';

class ClothingItem extends StatefulWidget {
  ClothingItem({Key key, this.clothingItem}) : super(key: key);

  final clothingItem;

  @override
  _ClothingItemState createState() => _ClothingItemState();
}

class _ClothingItemState extends State<ClothingItem> {
  ClothingItemObject clothingID;
  CurrentUser user = CurrentUser.getInstance();
  var progress;
  int timesWorn;
  int karma = 0;
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

    this.timesWorn = clothingID.data.currentTimesWorn.round();
    this.lastWorn = clothingID.data.lastWornDate;
    this.progress =  this.timesWorn / this.clothingID.data.maxNoOfTimesToBeWorn;
  }

  void updateProgress(String action) async {
    int amount =
        (this.clothingID.data.cF / this.clothingID.data.maxNoOfTimesToBeWorn)
            .round();

    setState(() {
      if (action == 'INC') {
        this.timesWorn++;
        this.karma += amount;
        this.lastWorn = DateTime.now().toString();
      } else {
        if (this.timesWorn > 0) {
          this.timesWorn--;
          this.karma -= amount;
        }
      }
      this.progress =
          this.timesWorn / this.clothingID.data.maxNoOfTimesToBeWorn;
    });

    await api_client
        .post("/closet/updateItem",
            body: jsonEncode(<String, dynamic>{
              'uid': user.getUID(),
              'clothingId': this.clothingID.id,
              'timesWorn': this.timesWorn,
              'lastWorn': DateTime.now().toString(),
              'carmaGain': amount
            }))
        .then((e) {
      print(e.statusCode);
      print(e.body);
    });

    if (this.timesWorn == this.clothingID.data.maxNoOfTimesToBeWorn &&
        this.timesWorn != 0) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                child: Text(
                    "Congrats! You have used this piece of clothing sustainably!"));
          });
    }
  }

  String customFormatDateTime(String string) {
    DateTime datetime = DateTime.parse(string);
    return DateFormat('dd MMM yy').format(datetime);
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
                  Padding(padding: EdgeInsets.only(top: 35)),
                  SizedBox(
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
                  Padding(padding: EdgeInsets.only(top: 5.0)),
                  ButtonBar(
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
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )
                ])),
            Padding(padding: EdgeInsets.only(top: 10)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10)),
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
                          value:
                              StringOperator.capitalise(clothingID.data.brand),
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
                              "${this.karma} / ${this.clothingID.data.cF.round()}",
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
          ],
        ),
        bottomNavigationBar: NavBar(selected: 1));
  }
}
