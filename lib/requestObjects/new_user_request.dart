import 'package:json_annotation/json_annotation.dart';

part 'new_user_request.g.dart';

@JsonSerializable()

class NewUserRequest {
  String uid;
  String username;

  NewUserRequest(this.uid, this.username);

  Map<String, dynamic> toJson() => _$NewUserRequestToJson(this);
}