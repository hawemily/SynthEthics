import 'package:json_annotation/json_annotation.dart';

import 'clothingItemObject.dart';

part 'clothingTypeObject.g.dart';

@JsonSerializable()

class ClothingTypeObject {
  @JsonKey(includeIfNull: false)
  String clothingType;
  List<ClothingItemObject> clothingItems;

  ClothingTypeObject(this.clothingType, this.clothingItems);

  factory ClothingTypeObject.fromJson(Map<String, dynamic> json) {
    return _$ClothingTypeObjectFromJson(json);
  }
}