import 'dart:io';

import 'package:path_provider/path_provider.dart';


///
/// Helper service for managing the storing and loading of images
///
class ImageManager {
  Future<String> _imageDirPath;
  static ImageManager _instance;

  ImageManager._internal();

  static ImageManager getInstance() {
    if (_instance == null) {
      _instance = ImageManager._internal();
      _instance._imageDirPath = _getImageDirPath();
    }

    return _instance;
  }

  static Future<String> _getImageDirPath() async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    return "$path/images";
  }

  Future<File> savePictureToDevice(File image, String filename) async {
    try {
      final imageDir = await _imageDirPath;
      if (!(await Directory(imageDir).exists())) {
        await Directory(imageDir).create();
      }
      final File newImage = await image.copy("$imageDir/$filename.png");
      return newImage;
    } catch (e) {
      print("error $e");
      return null;
    }
  }

  Future<File> loadPictureFromDevice(String filename) async {
    try {
      final imageDir = await _imageDirPath;
      print(imageDir);
      final imageToLoad = File("$imageDir/$filename.png");
      if (await imageToLoad.exists()) {
        return imageToLoad;
      }
    } catch (e) {
      print("error $e");
    }
    return null;
  }
}
