import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/responseObjects/outfitObject.dart';

part 'getOutfitResponse.g.dart';

@JsonSerializable()
class GetOutfitResponse {
  final List<OutfitObject> outfits;

  GetOutfitResponse(this.outfits);

  factory GetOutfitResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOutfitResponseFromJson(json);
}
