class StatsModel {
  int totalTimesToWear;
  int timesWorn;
  String material;
  String itemName;
  int carma;
  String brand;
  String lastWorn;
  String purchaseDate;

  StatsModel.fromJson(Map<String, dynamic> parsedJson) {
    totalTimesToWear = parsedJson['totalTimesToWear'];
    timesWorn = parsedJson['timesWorn'];
    material = parsedJson['material'];
    itemName = parsedJson['itemName'];
    carma = parsedJson['carma'];
    brand = parsedJson['brand'];
    lastWorn = parsedJson['lastWorn'];
    purchaseDate = parsedJson['purchaseDate'];
  }
}
