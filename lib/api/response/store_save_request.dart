import 'package:json_annotation/json_annotation.dart';
import '../../database/store_entity.dart';

part 'store_save_request.g.dart';

@JsonSerializable()
class StoreSaveRequest{
  final String user_id;
  final List<StoreEntity> store_list;

  StoreSaveRequest({
    required this.user_id,
    required this.store_list,
  });

  factory StoreSaveRequest.fromJson(Map<String, dynamic> json) => _$StoreSaveRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StoreSaveRequestToJson(this);

}