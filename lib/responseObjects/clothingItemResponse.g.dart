// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothingItemResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothingItemResponse _$ClothingItemResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id']);
  return ClothingItemResponse(
    json['id'] as String,
    json['data'] == null
        ? null
        : ClothingItem.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ClothingItemResponseToJson(
        ClothingItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
    };
