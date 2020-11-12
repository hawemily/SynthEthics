import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'clothingItemObject.dart';

part 'outfitObject.g.dart';

@JsonSerializable()
class OutfitObject {
  @JsonKey(required: true)
  final String name;
  final List<ClothingItemObject> clothing;

  OutfitObject(this.name, this.clothing);

  factory OutfitObject.fromJson(Map<String, dynamic> json) =>
      _$OutfitObjectFromJson(json);
}
