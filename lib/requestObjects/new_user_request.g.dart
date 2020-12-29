// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewUserRequest _$NewUserRequestFromJson(Map<String, dynamic> json) {
  return NewUserRequest(
    json['uid'] as String,
    json['username'] as String,
  );
}

Map<String, dynamic> _$NewUserRequestToJson(NewUserRequest instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
    };
