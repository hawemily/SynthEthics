import 'package:json_annotation/json_annotation.dart';

part 'clothingTypeObject.g.dart';

@JsonSerializable()

class ClothingTypeObject {
  String clothingType;
  List<ClothingTypeObject> clothingItems;

  ClothingTypeObject(this.clothingType, this.clothingItems);

  factory ClothingTypeObject.fromJson(Map<String, dynamic> json) => _$ClothingTypeObjectFromJson(json);
}