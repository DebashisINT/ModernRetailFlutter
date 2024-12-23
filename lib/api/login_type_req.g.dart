// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_type_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginTypeReq _$LoginTypeReqFromJson(Map<String, dynamic> json) => LoginTypeReq(
      login_id: json['login_id'] as String,
      login_password: json['login_password'] as String,
      app_version: json['app_version'] as String,
      device_token: json['device_token'] as String,
    );

Map<String, dynamic> _$LoginTypeReqToJson(LoginTypeReq instance) =>
    <String, dynamic>{
      'login_id': instance.login_id,
      'login_password': instance.login_password,
      'app_version': instance.app_version,
      'device_token': instance.device_token,
    };
