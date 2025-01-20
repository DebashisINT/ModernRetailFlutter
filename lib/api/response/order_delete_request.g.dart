// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_delete_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDeleteRequest _$OrderDeleteRequestFromJson(Map<String, dynamic> json) =>
    OrderDeleteRequest(
      user_id: json['user_id'] as String? ?? "",
      order_delete_list: (json['order_delete_list'] as List<dynamic>)
          .map((e) => OrderDelete.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDeleteRequestToJson(OrderDeleteRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'order_delete_list': instance.order_delete_list,
    };

OrderDelete _$OrderDeleteFromJson(Map<String, dynamic> json) => OrderDelete(
      order_id: json['order_id'] as String,
    );

Map<String, dynamic> _$OrderDeleteToJson(OrderDelete instance) =>
    <String, dynamic>{
      'order_id': instance.order_id,
    };
