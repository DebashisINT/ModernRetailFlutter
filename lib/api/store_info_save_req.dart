import 'package:flutter_demo_one/database/store_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'store_info_save_req.g.dart';

@JsonSerializable()
class StoreInfoSaveReq {
  @JsonKey(name: "user_id")
  final String user_id;

  @JsonKey(name: "store_list")
  final List<StoreEntity> store_list;

  StoreInfoSaveReq({
    required this.user_id,
    required this.store_list,
  });

  factory StoreInfoSaveReq.fromJson(Map<String, dynamic> json) =>
      _$StoreInfoSaveReqFromJson(json);

  Map<String, dynamic> toJson() => _$StoreInfoSaveReqToJson(this);

}
