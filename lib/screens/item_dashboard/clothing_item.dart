import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';

class ClothingItem extends StatefulWidget {
  ClothingItem({Key key, this.clothingId}) : super(key: key);

  final clothingId;

  @override
  _ClothingItemState createState() => _ClothingItemState();
}

class _ClothingItemState extends State<ClothingItem> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('Black Crop Top', style: TextStyle(color: Colors.black)),
        ),
        body: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 80.0)),
            SizedBox(
              height: 180.0,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      child: new CircularProgressIndicator(
                        strokeWidth: 30,
                        value: 0.6,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://cdn.endource.com/image/s3-49f2938a8e4d8f6c74bccbd2bf800c06/detail/and-other-stories-ribbed-square-neck-crop-top.jpg")))),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavBar());
//        ClosetContainer(clothingIds: List.generate(20, (index) => index))
  }
}
