import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart';
import 'package:synthetics/services/api_client.dart';

class LocalDatabaseInitialiser {

  static Future<Response> initUsers(String uid) async {
    return await api_client.post("/initUsers", body: jsonEncode({"uid": uid}));
  }

  static Future<Response> initAchievements() async {
    return await api_client.get("/initAchievements");
  }

  static Future<Response> initOutfits() async {
    return await api_client.get("/initOutfits");
  }

  static Future<Response> initCloset() async {
    return await api_client.get("/initCloset");
  }
}