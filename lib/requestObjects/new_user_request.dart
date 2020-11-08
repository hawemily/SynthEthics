import 'package:json_annotation/json_annotation.dart';

part 'new_user_request.g.dart';

@JsonSerializable()

class NewUserRequest {
  String uid;

  NewUserRequest(this.uid);

  Map<String, dynamic> toJson() => _$NewUserRequestToJson(this);
}