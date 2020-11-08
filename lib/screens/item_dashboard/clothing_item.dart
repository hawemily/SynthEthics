import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/screens/item_dashboard/stats_model.dart';
import 'package:synthetics/screens/item_dashboard/widgets/info_block.dart';
import 'package:synthetics/services/image_taker/image_manager.dart';
import 'package:synthetics/theme/custom_colours.dart';

class ClothingItem extends StatefulWidget {
  ClothingItem({Key key, this.clothingItem}) : super(key: key);

  final clothingItem;

  @override
  _ClothingItemState createState() => _ClothingItemState();
}

class _ClothingItemState extends State<ClothingItem> {
  ClothingItemObject clothingID;
  var progress = 0.0;

  int timesWorn;

  File image;

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
  }

  void updateProgress(String action) {
    setState(() {
      if (action == 'INC') {
        this.timesWorn++;
      } else {
        if (this.timesWorn > 0) this.timesWorn--;
      }
      this.progress =
          // this.timesWorn / this.clothingID.data.maxNoOfTimesToBeWorn;
          this.timesWorn / 15;
    });

    if (this.timesWorn == this.clothingID.data.maxNoOfTimesToBeWorn) {
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
    return DateFormat('dd/MM/yy').format(datetime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColours.greenNavy(),
          iconTheme: IconThemeData(color: Colors.white),
          title:
              Text(clothingID.data.name, style: TextStyle(color: Colors.white)),
        ),
        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0)),
            SizedBox(
              height: 180.0,
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
                      width: 180,
                      height: 180,
                      child: new CircularProgressIndicator(
                        strokeWidth: 30,
                        value: progress,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        backgroundColor: Colors.grey,
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
                                    : FileImage(this.image))
                            )
                        )
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 15.0)),
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              buttonHeight: 60,
              buttonMinWidth: 60,
              children: [
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.black,
                  child: Text("Wear"),
                  onPressed: () => updateProgress('INC'),
                  shape: new CircleBorder(),
                ),
                IconButton(
                  icon: Icon(Icons.undo),
                  tooltip: 'Undo',
                  onPressed: () => updateProgress('DEC'),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Colors.black,
                  child: Text("Donate"),
                  onPressed: () {},
                  shape: new CircleBorder(),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoBlock(
                  color: Colors.deepOrange[600],
                  value: clothingID.data.brand,
                  label: 'Shop',
                ),
                InfoBlock(
                  color: Colors.blue[600],
                  // TODO: Replace once multiple materials is implemented
                  value: clothingID.data.materials[0],
                  label: 'Material',
                ),
                InfoBlock(
                  color: Colors.green[900],
                  value: "${clothingID.data.cF.round()} Carma",
                  label: 'Points',
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoBlock(
                  color: Colors.black,
                  value:
                      // "${this.timesWorn}/${clothingID.data.maxNoOfTimesToBeWorn}",
                  // TODO Replace with proper value after backend fix
                  "${this.timesWorn}/15",
                  label: 'Times Worn',
                ),
                InfoBlock(
                  color: Colors.deepPurple[900],
                  value: customFormatDateTime(clothingID.data.purchaseDate),
                  label: 'Purchase Date',
                ),
                InfoBlock(
                  color: Colors.red[900],
                  value: customFormatDateTime(clothingID.data.lastWornDate),
                  label: 'Last Worn',
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: NavBar(selected: 1));
  }
}
