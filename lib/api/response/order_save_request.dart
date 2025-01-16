import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:modern_retail/database/order_save_dtls_entity.dart';
part 'order_save_request.g.dart';

@JsonSerializable()
class OrderSaveRequest{
  final String user_id;
  final String store_id;
  final String order_id;
  final String order_date_time;
  final String order_amount;
  final String order_status;
  final String remarks;
  final List<OrderSaveDtlsEntity> order_details_list;

  OrderSaveRequest({
    required this.user_id,
    required this.store_id,
    required this.order_id,
    required this.order_date_time,
    required this.order_amount,
    required this.order_status,
    required this.remarks,
    required this.order_details_list
  });

  factory OrderSaveRequest.fromJson(Map<String, dynamic> json) => _$OrderSaveRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OrderSaveRequestToJson(this);

}