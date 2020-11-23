import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:synthetics/services/image_taker/image_taker.dart';

class ClothingColourPage extends StatefulWidget {
  @override
  _ClothingColourPageState createState() => _ClothingColourPageState();
}

class _ClothingColourPageState extends State<ClothingColourPage> {

  Future<void> fetchDominantColours(String image) async {
    final Future<http.Response> response = http.post(
        "https://api.ximilar.com/dom_colors/product/v2/dominantcolor",
        body: {"_base64" : image});

    response.then((value) {
      print(value.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Colour Room")),
      body: Container(
        child: Center(
          child: Column(
            children: [
              IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () => ImageTaker.settingModalBottomSheet(context,
                      (Future<File> fileFuture) {
                        fileFuture.then((file) async {
                          if (file != null) {
                            List<int> imageBytes = await file.readAsBytes();
                            print(imageBytes);
                            await fetchDominantColours(base64Encode(imageBytes));
                          }
                        });
                      })),
            ],
          )
        )
      ),
    );
  }
}
