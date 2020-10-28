
class ClothingTypes {
  Future<List<String>> types;
  static ClothingTypes _instance;

  ClothingTypes._internal();

  static ClothingTypes getInstance() {
    if (_instance == null) {
      _instance = ClothingTypes._internal();
      _instance.types = _getClothingTypes();
    }
    return _instance;
  }

  static Future<List<String>> _getClothingTypes() async {
    // Assume backend will store types as all lowercase strings
    final types = [
      "tops",
      "bottoms",
      "skirts",
      "dresses",
      "outerwear",
      "headgear"
    ];
    return types;
  }
}