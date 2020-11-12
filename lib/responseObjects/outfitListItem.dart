import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/responseObjects/outfitObject.dart';
import 'outfitObject.dart';

part 'outfitListItem.g.dart';

@JsonSerializable()
class OutfitListItem {
  @JsonKey(required: true)
  final String id;
  final OutfitObject data;

  OutfitListItem(this.id, this.data);

  factory OutfitListItem.fromJson(Map<String, dynamic> json) =>
      _$OutfitListItemFromJson(json);
}
