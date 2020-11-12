import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/responseObjects/outfitListItem.dart';

part 'getOutfitResponse.g.dart';

@JsonSerializable()
class GetOutfitResponse {
  final List<OutfitListItem> outfits;

  GetOutfitResponse(this.outfits);

  factory GetOutfitResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOutfitResponseFromJson(json);
}
