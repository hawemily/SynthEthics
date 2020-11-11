import 'package:json_annotation/json_annotation.dart';

part 'donated_item_metadata.g.dart';

@JsonSerializable()
class DonatedItemMetadata {
  String id;

  DonatedItemMetadata(this.id);


  @override
  bool operator ==(other) {
    return (other is DonatedItemMetadata) &&
        other.id == this.id;
  }

  Map<String, dynamic> toJson() => _$DonatedItemMetadataToJson(this);

  @override
  int get hashCode => id.hashCode;

  static fromJson(Map<String, dynamic> e) {}

}