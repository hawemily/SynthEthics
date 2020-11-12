import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/responseObjects/getOutfitResponse.dart';
import 'package:synthetics/services/api_client.dart';
import 'package:synthetics/theme/custom_colours.dart';

import 'outfitContainer.dart';

class DressingRoom extends StatefulWidget {
  @override
  _DressingRoomState createState() => _DressingRoomState();
}

class _DressingRoomState extends State<DressingRoom> {
  Future<GetOutfitResponse> outfits;

  @override
  void initState() {
    super.initState();
    outfits = this.getOutfits();
  }

  Future<GetOutfitResponse> getOutfits() async {
    print("trying get all outfits from backend");
    final response = await api_client.get("/outfits");

    if (response.statusCode == 200) {
      print(response.body);
      final resBody = jsonDecode(response.body);
      final closet = GetOutfitResponse.fromJson(resBody);
      return closet;
    } else {
      throw Exception("Failed to load closet");
    }
  }

  Widget generateOutfits() {
    return FutureBuilder<GetOutfitResponse>(
        future: outfits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return OutfitContainer(
              outfits: snapshot.data.outfits,
            );
          } else if (snapshot.hasError) {
            return Text(
                "Unable to load clothes from closet! Please contact admin for support");
          }
          return CircularProgressIndicator();
        });
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColours.greenNavy(),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Dressing Room'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: generateOutfits(),
        ),
      ),
      bottomNavigationBar: NavBar(selected: 3),
    );
  }
}
