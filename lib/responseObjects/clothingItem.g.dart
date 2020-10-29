// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothingItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothingItem _$ClothingItemFromJson(Map<String, dynamic> json) {
  return ClothingItem(
    json['name'] as String ?? 'Unnamed Item',
    json['brand'] as String ?? 'Unbranded',
    json['cF'] as int ?? 0,
    (json['materials'] as List)?.map((e) => e as String)?.toList(),
    json['lastWornDate'] as String ?? '25/10/2020',
    json['purchaseDate'] as String ?? '25/10/2020',
    json['currentTimesWorn'] as int ?? 0,
    json['maxNoOfTimesToBeWorn'] as int ?? 0,
  );
}

Map<String, dynamic> _$ClothingItemToJson(ClothingItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'brand': instance.brand,
      'cF': instance.cF,
      'materials': instance.materials,
      'lastWornDate': instance.lastWornDate,
      'purchaseDate': instance.purchaseDate,
      'currentTimesWorn': instance.currentTimesWorn,
      'maxNoOfTimesToBeWorn': instance.maxNoOfTimesToBeWorn,
    };
