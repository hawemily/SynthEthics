import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/responseObjects/clothingMetadata.dart';

part 'clothingItemObject.g.dart';

@JsonSerializable()

class ClothingItemObject {
  @JsonKey(required: true)
  final String id;
  final ClothingMetadata data;

  ClothingItemObject(
    this.id,
    this.data
  );

  factory ClothingItemObject.fromJson(Map<String, dynamic> json) => _$ClothingItemObjectFromJson(json);
}

