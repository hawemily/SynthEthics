// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothingMetadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothingMetadata _$ClothingMetadataFromJson(Map<String, dynamic> json) {
  return ClothingMetadata(
    json['name'] as String ?? 'Unnamed Item',
    json['brand'] as String ?? 'Unbranded',
    (json['cF'] as num)?.toDouble() ?? 0,
    (json['materials'] as List)?.map((e) => e as String)?.toList(),
    json['lastWornDate'] as String ?? '25/10/2020',
    json['purchaseDate'] as String ?? '25/10/2020',
    (json['currentTimesWorn'] as num)?.toDouble() ?? 0,
    (json['maxNoOfTimesToBeWorn'] as num)?.toDouble() ?? 0,
    json['dominantColor'] as int ?? 1,
    json['clothingType'] as String ?? '',
    json['donated'] as bool ?? false,
  );
}

Map<String, dynamic> _$ClothingMetadataToJson(ClothingMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'brand': instance.brand,
      'cF': instance.cF,
      'materials': instance.materials,
      'lastWornDate': instance.lastWornDate,
      'purchaseDate': instance.purchaseDate,
      'currentTimesWorn': instance.currentTimesWorn,
      'maxNoOfTimesToBeWorn': instance.maxNoOfTimesToBeWorn,
      'clothingType': instance.clothingType,
      'dominantColor': instance.dominantColor,
      'donated': instance.donated,
    };
