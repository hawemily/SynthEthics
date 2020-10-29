// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getClosetResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetClosetResponse _$GetClosetResponseFromJson(Map<String, dynamic> json) {
  return GetClosetResponse(
    (json['clothingItems'] as List)
        ?.map((e) => e == null
            ? null
            : ClothingItemObject.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GetClosetResponseToJson(GetClosetResponse instance) =>
    <String, dynamic>{
      'clothingItems': instance.clothingItems,
    };
