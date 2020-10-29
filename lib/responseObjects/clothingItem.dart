import 'package:json_annotation/json_annotation.dart';

part 'clothingItem.g.dart';

@JsonSerializable()

class ClothingItem {

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

  ClothingItem(this.name,
    this.brand,
    this.cF,
    this.materials,
    this.lastWornDate,
    this.purchaseDate,
    this.currentTimesWorn,
    this.maxNoOfTimesToBeWorn);

  factory ClothingItem.fromJson(Map<String, dynamic> json) => _$ClothingItemFromJson(json);

  Map<String, dynamic> toJson() => _$ClothingItemToJson(this);
}
