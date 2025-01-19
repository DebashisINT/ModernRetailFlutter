import 'package:json_annotation/json_annotation.dart';

part 'order_delete_request.g.dart';

@JsonSerializable()
class OrderDeleteRequest {
  String user_id;
  List<OrderDelete> order_delete_list;

  OrderDeleteRequest({
    this.user_id="",
    required this.order_delete_list,
  });

  factory OrderDeleteRequest.fromJson(Map<String, dynamic> json) => _$OrderDeleteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDeleteRequestToJson(this);
}

@JsonSerializable()
class OrderDelete {
  final String order_id;

  OrderDelete({required this.order_id});

  factory OrderDelete.fromJson(Map<String, dynamic> json) => _$OrderDeleteFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDeleteToJson(this);
}
