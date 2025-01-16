// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSaveRequest _$OrderSaveRequestFromJson(Map<String, dynamic> json) =>
    OrderSaveRequest(
      user_id: json['user_id'] as String,
      store_id: json['store_id'] as String,
      order_id: json['order_id'] as String,
      order_date_time: json['order_date_time'] as String,
      order_amount: json['order_amount'] as String,
      order_status: json['order_status'] as String,
      remarks: json['remarks'] as String,
      order_details_list: (json['order_details_list'] as List<dynamic>)
          .map((e) => OrderSaveDtlsEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderSaveRequestToJson(OrderSaveRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'store_id': instance.store_id,
      'order_id': instance.order_id,
      'order_date_time': instance.order_date_time,
      'order_amount': instance.order_amount,
      'order_status': instance.order_status,
      'remarks': instance.remarks,
      'order_details_list': instance.order_details_list,
    };
