import 'package:json_annotation/json_annotation.dart';

part 'order_delete_request.g.dart';

@JsonSerializable()
class OrderDeleteRequest {
  final String user_id;
  final List<OrderDelete> order_delete_list;

  OrderDeleteRequest({
    required this.user_id,
    required this.order_delete_list,
  });

  // Factory for deserializing JSON
  factory OrderDeleteRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderDeleteRequestFromJson(json);

  // Method for serializing to JSON
  Map<String, dynamic> toJson() => _$OrderDeleteRequestToJson(this);
}

@JsonSerializable()
class OrderDelete {
  final String order_id;

  OrderDelete({required this.order_id});

  // Factory for deserializing JSON
  factory OrderDelete.fromJson(Map<String, dynamic> json) =>
      _$OrderDeleteFromJson(json);

  // Method for serializing to JSON
  Map<String, dynamic> toJson() => _$OrderDeleteToJson(this);
}
