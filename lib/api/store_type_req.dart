
import 'package:flutter_demo_one/database/store_type_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'store_type_req.g.dart';

@JsonSerializable()
class StoreTypeReq {
  final String user_id;

  StoreTypeReq({required this.user_id});

  factory StoreTypeReq.fromJson(Map<String, dynamic> json) => _$StoreTypeReqFromJson(json);
  Map<String, dynamic> toJson() => _$StoreTypeReqToJson(this);
}