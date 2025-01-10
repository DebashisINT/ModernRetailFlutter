import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String login_id;
  final String login_password;
  final String app_version;
  final String device_token;

  LoginRequest({required this.login_id , required this.login_password , required this.app_version , required this.device_token });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}