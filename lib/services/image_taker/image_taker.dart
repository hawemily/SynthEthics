import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';


/// Image Taker, called by the NavBar when adding items to the closet
/// Currently goes to image display page, in the future it should go to a
/// Confirmation page where an item instance is created
class ImageTaker {
  static void settingModalBottomSheet(BuildContext context, Function callBack) {
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
                  callBack(
                      _modalGetPictureWrapper(context, ImageSource.camera));
                },
              ),
              ListTile(
                title: Text('Select a photo from gallery'),
                onTap: () {
                  print('select from gallery');
                  callBack(
                      _modalGetPictureWrapper(context, ImageSource.gallery));
                },
              )
            ],
          ));
        });
  }

  static Future<File> _modalGetPictureWrapper(
      BuildContext context, ImageSource imageSource) {
    final image = _getPicture(context, imageSource);
    // Remove the modal from the screen before returning
    Navigator.pop(context);
    return image;
  }

  static Future<File> _getPicture(BuildContext context,
                                  ImageSource imageSource) async {
    File image;
    ImagePicker imagePicker = ImagePicker();
    final pickedFile =
        await imagePicker.getImage(source: imageSource, imageQuality: 50);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }

    // Debug messages
    if (image != null) {
      print("You selected  image : " + image.path);
    } else {
      print("You have not taken image");
    }
    return image;
  }
}
