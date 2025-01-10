// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreSaveRequest _$StoreSaveRequestFromJson(Map<String, dynamic> json) =>
    StoreSaveRequest(
      user_id: json['user_id'] as String,
      store_list: (json['store_list'] as List<dynamic>)
          .map((e) => StoreEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreSaveRequestToJson(StoreSaveRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'store_list': instance.store_list,
    };
