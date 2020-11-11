import 'package:json_annotation/json_annotation.dart';
import 'package:synthetics/requestObjects/donated_item_metadata.dart';

part 'items_to_donate_request.g.dart';

@JsonSerializable()

class ItemsToDonateRequest{
  String uid;
  List<DonatedItemMetadata> items;

  ItemsToDonateRequest(this.uid, this.items);

  Map<String, dynamic> toJson() => _$ItemsToDonateRequestToJson(this);
}