
class ClothingMaterials {
  Future<List<String>> types;
  static ClothingMaterials _instance;

  ClothingMaterials._internal();

  static ClothingMaterials getInstance() {
    if (_instance == null) {
      _instance = ClothingMaterials._internal();
      _instance.types = _getClothingTypes();
    }
    return _instance;
  }

  static Future<List<String>> _getClothingTypes() async {
    final materials = [
      "Acrylic",
      "Bamboo",
      "Cotton",
      "Hemp",
      "Jute",
      "Leather",
      "Linen",
      "Lyocell",
      "Nylon",
      "Organic Cotton",
      "Polyester",
      "Polypropylene",
      "Recycled Polyester",
      "Silk",
      "Spandex",
      "Synthetic Leather",
      "Viscose",
      "Wool",
    ];
    return materials;
  }

  int containsMaterial(List<String> materials, String material) {
    final upperMaterial = material.toUpperCase();
    for (int i = 0; i < materials.length; i++) {
      if (materials[i].toUpperCase() == upperMaterial) {
        return i;
      }
    }
    return -1;
  }

  String materialMapping(String material) {
    Map<String, String> materialMap = {
      "Acrylic": "acrylic",
      "Bamboo": "bamboo",
      "Cotton": "cotton",
      "Hemp": "hemp",
      "Jute": "jute",
      "Leather": "leather",
      "Linen": "linen",
      "Lyocell": "lyocell",
      "Nylon": "nylon",
      "Organic Cotton": "cotton_organic",
      "Polyester": "polyester",
      "Polypropylene": "polypropylene",
      "Recycled Polyester": "polyester_recycled",
      "Silk": "silk",
      "Spandex": "spandex",
      "Synthetic Leather": "leather_synthetic",
      "Viscose": "viscose",
      "Wool": "wool",
    };

    return materialMap[material];
  }
}
