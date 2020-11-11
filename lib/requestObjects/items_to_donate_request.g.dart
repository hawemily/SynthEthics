// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_to_donate_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemsToDonateRequest _$ItemsToDonateRequestFromJson(Map<String, dynamic> json) {
  return ItemsToDonateRequest(
    (json['items'] as List)
        ?.map((e) => e == null
            ? null
            : DonatedItemMetadata.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ItemsToDonateRequestToJson(
        ItemsToDonateRequest instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
