import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';
import 'package:synthetics/responseObjects/clothingTypeObject.dart';

part 'getClosetResponse.g.dart';

@JsonSerializable()

class GetClosetResponse {
  final List<ClothingTypeObject> clothingTypes;

  GetClosetResponse(
      this.clothingTypes);

  factory GetClosetResponse.fromJson(Map<String, dynamic> json) => _$GetClosetResponseFromJson(json);
}