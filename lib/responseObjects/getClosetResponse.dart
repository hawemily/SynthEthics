import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/responseObjects/clothingItemObject.dart';

part 'getClosetResponse.g.dart';

@JsonSerializable()

class GetClosetResponse {
  final List<ClothingItemObject> clothingItems;

  GetClosetResponse(
      this.clothingItems);

  factory GetClosetResponse.fromJson(Map<String, dynamic> json) => _$GetClosetResponseFromJson(json);
}