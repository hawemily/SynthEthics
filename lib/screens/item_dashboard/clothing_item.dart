import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/screens/item_dashboard/stats_model.dart';
import 'package:synthetics/screens/item_dashboard/widgets/info_block.dart';

class ClothingItem extends StatefulWidget {
  ClothingItem({Key key, this.clothingData}) : super(key: key);

  final clothingData;

  @override
  _ClothingItemState createState() => _ClothingItemState();
}

class _ClothingItemState extends State<ClothingItem> {
  StatsModel clothingID;
  var progress = 0.0;

  @override
  void initState() {
    super.initState();

    /* replace rawJson with clothing data json object passed */
    var rawJson =
        '{"totalTimesToWear" : 15, "timesWorn" : 0, "itemName" : "Black Crop Top", "carma" : 50, "brand" : "Zara", "lastWorn" : "16 Sep 20", "purchaseDate" : "24 Aug 20", "material": "Cotton"}';
    var parsedjson = json.decode(rawJson);
    this.clothingID = StatsModel.fromJson(parsedjson);
  }

  void updateProgress(String action) {
    setState(() {
      if (action == 'INC') {
        this.clothingID.timesWorn++;
      } else {
        if (this.clothingID.timesWorn > 0) this.clothingID.timesWorn--;
      }
      this.progress =
          this.clothingID.timesWorn / this.clothingID.totalTimesToWear;
    });

    if (this.clothingID.timesWorn == this.clothingID.totalTimesToWear) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                child: Text(
                    "Congrats! You have used this piece of clothing sustainably!"));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          iconTheme: IconThemeData(color: Colors.black),
          title:
              Text(clothingID.itemName, style: TextStyle(color: Colors.black)),
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
                    ),
                  ),
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
                                // fit: BoxFit.fitHeight,
                                image: new NetworkImage(
                                    "https://cdn.endource.com/image/s3-49f2938a8e4d8f6c74bccbd2bf800c06/detail/and-other-stories-ribbed-square-neck-crop-top.jpg")))),
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
                  value: clothingID.brand,
                  label: 'Shop',
                ),
                InfoBlock(
                  color: Colors.blue[600],
                  value: clothingID.material,
                  label: 'Material',
                ),
                InfoBlock(
                  color: Colors.green[900],
                  value: clothingID.carma.toString() + " Carma",
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
                  value: clothingID.timesWorn.toString() +
                      "/" +
                      clothingID.totalTimesToWear.toString(),
                  label: 'Times Worn',
                ),
                InfoBlock(
                  color: Colors.deepPurple[900],
                  value: clothingID.purchaseDate.toString(),
                  label: 'Purchase Date',
                ),
                InfoBlock(
                  color: Colors.red[900],
                  value: clothingID.lastWorn.toString(),
                  label: 'Last Worn',
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: NavBar());
  }
}
