import 'package:json_annotation/json_annotation.dart';

part 'user_id_request.g.dart';

@JsonSerializable()
class UserIdRequest {
  final String user_id;

  UserIdRequest({required this.user_id});

  factory UserIdRequest.fromJson(Map<String, dynamic> json) => _$UserIdRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UserIdRequestToJson(this);
}