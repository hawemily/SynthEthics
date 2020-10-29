// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothingItemObject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothingItemObject _$ClothingItemObjectFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id']);
  return ClothingItemObject(
    json['id'] as String,
    json['data'] == null
        ? null
        : ClothingMetadata.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ClothingItemObjectToJson(ClothingItemObject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
    };
