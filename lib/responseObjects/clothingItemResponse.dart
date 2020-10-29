import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/responseObjects/clothingItem.dart';

part 'clothingItemResponse.g.dart';

@JsonSerializable()

class ClothingItemResponse {
  @JsonKey(required: true)
  final String id;
  final ClothingItem data;

  ClothingItemResponse(
    this.id,
    this.data
  );

  factory ClothingItemResponse.fromJson(Map<String, dynamic> json) => _$ClothingItemResponseFromJson(json);
//  Map<String, dynamic> toJson() => _$ClothingItemResponseToJson(this);
}

