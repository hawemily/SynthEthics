import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as ImageOps;
import 'package:palette_generator/palette_generator.dart';

class ColourFetcher {

  static ImageOps.Image _cropToCenter(ImageOps.Image image, double portion) {
    print("height: ${image.height} width: ${image.width}");
    final int cropHeight = (image.height * portion).round();
    final int cropWidth = (image.width * portion).round();
    final int yStart = ((image.height - cropHeight) / 2).round();
    final int xStart = ((image.width - cropWidth) / 2).round();
    return ImageOps.copyCrop(image, xStart, yStart, cropWidth, cropHeight);
  }

  static Future<ui.Color> fetchDominantColour(File fileImage) async {
    ImageOps.Image customImage = ImageOps.decodeImage(fileImage.readAsBytesSync());
    customImage = _cropToCenter(customImage, 0.8);

    ui.Codec codec = await ui.instantiateImageCodec(ImageOps.encodePng(customImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImage(frameInfo.image);

    return paletteGenerator.dominantColor.color;
  }
}