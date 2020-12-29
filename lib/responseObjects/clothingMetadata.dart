import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/screens/clothing_colour_page/color_classifier.dart';
import 'package:synthetics/services/clothing_types/clothing_types.dart';

part 'clothingMetadata.g.dart';

@JsonSerializable()

class ClothingMetadata {

  @JsonKey(defaultValue: "Unnamed Item")
  final String name;

  @JsonKey(defaultValue: "Unbranded")
  final String brand;

  @JsonKey(defaultValue: 0)
  final double cF;

  final List<String> materials;

  //TOOD: how to get current date
  @JsonKey(defaultValue: "25/10/2020")
  final String lastWornDate;

  @JsonKey(defaultValue: "25/10/2020")
  final String purchaseDate;

  @JsonKey(defaultValue: 0)
  final double currentTimesWorn;

  @JsonKey(defaultValue: 0)
  final double maxNoOfTimesToBeWorn;

  @JsonKey(defaultValue: "")
  final String clothingType;

  @JsonKey(defaultValue: 1)
  final int dominantColor;

  ClothingMetadata(this.name,
    this.brand,
    this.cF,
    this.materials,
    this.lastWornDate,
    this.purchaseDate,
    this.currentTimesWorn,
    this.maxNoOfTimesToBeWorn,
    this.dominantColor,
      this.clothingType);

  factory ClothingMetadata.fromJson(Map<String, dynamic> json) => _$ClothingMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$ClothingMetadataToJson(this);
}
