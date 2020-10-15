import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:synthetics/screens/image_taker_page/image_display_page.dart';


class ImageTakerPage extends StatefulWidget {
  @override
  ImageTakerPageState createState() => ImageTakerPageState();
}

class ImageTakerPageState extends State<ImageTakerPage> {

  void _modalGetPictureWrapper(ImageSource imageSource) {
    _getPicture(imageSource);
    Navigator.pop(context);
  }

  void _settingModalBottomSheet(BuildContext context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: Wrap(
                children: [
                  ListTile(
                    title: Text('Take a photo'),
                    onTap: () {
                      print("take a photo");
                      _modalGetPictureWrapper(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    title: Text('Select a photo from gallery'),
                    onTap: () {
                      print('select from gallery');
                      _modalGetPictureWrapper(ImageSource.gallery);
                    },
                  )
                ],
              )
            );
          }
      );
  }

  void _getPicture(ImageSource imageSource) async {
    File image;
    ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(
        source: imageSource, imageQuality: 50);
    if (pickedFile != null) {
        image = File(pickedFile.path);
    }

    if (image != null) {
      print("You selected  image : " + image.path);
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $image");
      });
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageDisplayPage(image: image))
      );
    } else {
      print("You have not taken image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prototype Image Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              padding: EdgeInsets.all(20),
              color: Colors.deepPurpleAccent,
              textColor: Colors.white,
              onPressed: () => _settingModalBottomSheet(context),
              child: Text("Scan item")
            ),
          ],
        ),
      ),
    );
  }
}