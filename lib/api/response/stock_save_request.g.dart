// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockSaveRequest _$StockSaveRequestFromJson(Map<String, dynamic> json) =>
    StockSaveRequest(
      user_id: json['user_id'] as String,
      stock_id: json['stock_id'] as String,
      save_date_time: json['save_date_time'] as String,
      store_id: json['store_id'] as String,
      product_list: (json['product_list'] as List<dynamic>)
          .map((e) => StockSaveDtlsEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StockSaveRequestToJson(StockSaveRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'stock_id': instance.stock_id,
      'save_date_time': instance.save_date_time,
      'store_id': instance.store_id,
      'product_list': instance.product_list,
    };
