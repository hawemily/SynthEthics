import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


/// Helper service for getting list of country names, to ensure frontend uses
/// the same list of country names as the backend
class CountryData {
  Future<List<Map<String, dynamic>>> countryData;
  static CountryData _instance;

  CountryData._internal();
  
  static CountryData getInstance() {
    if (_instance == null) {
      _instance = CountryData._internal();
      _instance.countryData = _initDb();
    }
    return _instance;
  }

  static Future<List<Map<String, dynamic>>> _initDb() async {
    final localPath = "lib/assets/countries.db";
    final dbPath = await getDatabasesPath();
    final databasePath = join(dbPath, "countries.db");

    // Ensure the parent directory exists
    try {
      await Directory(dirname(databasePath)).create(recursive: true);
    } catch (_) {}

    // Copy data from asset
    final data = await rootBundle.load(localPath);
    final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Wait for the write to complete
    await File(databasePath).writeAsBytes(bytes, flush: true);
    
    return (await openDatabase(databasePath, readOnly: true)).query('country_data');
  }

  // Returns index if found, -1 otherwise
  static int containsCountry(List<String> countryNames, String country) {
    for (int i = 0; i < countryNames.length; i++) {
      if (country.toUpperCase() == countryNames[i].toUpperCase()) {
        return i;
      }
    }
    return -1;
  }
}