import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/responseObjects/clothingMetadata.dart';
import 'package:synthetics/screens/item_dashboard/clothing_item.dart';

part 'outfitObject.g.dart';

@JsonSerializable()
class OutfitObject {
  @JsonKey(required: true)
  final String name;
  final List<ClothingItemObject> clothingitems;

  OutfitObject(this.name, this.clothingitems);

  factory OutfitObject.fromJson(Map<String, dynamic> json) =>
      _$OutfitObjectFromJson(json);
}
