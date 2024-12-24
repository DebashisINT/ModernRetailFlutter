
import 'package:flutter_demo_one/database/store_type_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_id_req.g.dart';

@JsonSerializable()
class UserIdReq {
  final String user_id;

  UserIdReq({required this.user_id});

  factory UserIdReq.fromJson(Map<String, dynamic> json) => _$UserIdReqFromJson(json);
  Map<String, dynamic> toJson() => _$UserIdReqToJson(this);
}