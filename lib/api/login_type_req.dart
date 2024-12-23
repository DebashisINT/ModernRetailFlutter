
import 'package:flutter_demo_one/database/store_type_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_type_req.g.dart';

@JsonSerializable()
class LoginTypeReq {
  final String login_id;
  final String login_password;
  final String app_version;
  final String device_token;

  LoginTypeReq({required this.login_id , required this.login_password , required this.app_version , required this.device_token });

  factory LoginTypeReq.fromJson(Map<String, dynamic> json) => _$LoginTypeReqFromJson(json);
  Map<String, dynamic> toJson() => _$LoginTypeReqToJson(this);
}