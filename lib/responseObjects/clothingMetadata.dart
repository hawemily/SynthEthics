import 'package:json_annotation/json_annotation.dart';

part 'clothingMetadata.g.dart';

@JsonSerializable()

class ClothingMetadata {

  @JsonKey(defaultValue: "Unnamed Item")
  final String name;

  @JsonKey(defaultValue: "Unbranded")
  final String brand;

  @JsonKey(defaultValue: 0)
  final int cF;

  final List<String> materials;

  //TOOD: how to get current date
  @JsonKey(defaultValue: "25/10/2020")
  final String lastWornDate;

  @JsonKey(defaultValue: "25/10/2020")
  final String purchaseDate;

  @JsonKey(defaultValue: 0)
  final int currentTimesWorn;

  @JsonKey(defaultValue: 0)
  final int maxNoOfTimesToBeWorn;

  ClothingMetadata(this.name,
    this.brand,
    this.cF,
    this.materials,
    this.lastWornDate,
    this.purchaseDate,
    this.currentTimesWorn,
    this.maxNoOfTimesToBeWorn);

  factory ClothingMetadata.fromJson(Map<String, dynamic> json) => _$ClothingMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$ClothingMetadataToJson(this);
}
