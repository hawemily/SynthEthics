import 'package:json_annotation/json_annotation.dart';

part 'session_object.g.dart';

@JsonSerializable()

class SessionObject {
  String uid;

  SessionObject(this.uid);

  Map<String, dynamic> toJson() => _$SessionObjectToJson(this);
}