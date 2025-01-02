// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreEntity _$StoreEntityFromJson(Map<String, dynamic> json) => StoreEntity(
      store_id: json['store_id'] as String,
      store_name: json['store_name'] as String,
      store_address: json['store_address'] as String,
      store_pincode: json['store_pincode'] as String,
      store_lat: json['store_lat'] as String,
      store_long: json['store_long'] as String,
      store_contact_name: json['store_contact_name'] as String,
      store_contact_number: json['store_contact_number'] as String,
      store_alternet_contact_number:
          json['store_alternet_contact_number'] as String,
      store_whatsapp_number: json['store_whatsapp_number'] as String,
      store_email: json['store_email'] as String,
      store_type: json['store_type'] as String,
      store_size_area: json['store_size_area'] as String,
      store_state_id: json['store_state_id'] as String,
      remarks: json['remarks'] as String,
      create_date_time: json['create_date_time'] as String,
    );

Map<String, dynamic> _$StoreEntityToJson(StoreEntity instance) =>
    <String, dynamic>{
      'store_id': instance.store_id,
      'store_name': instance.store_name,
      'store_address': instance.store_address,
      'store_pincode': instance.store_pincode,
      'store_lat': instance.store_lat,
      'store_long': instance.store_long,
      'store_contact_name': instance.store_contact_name,
      'store_contact_number': instance.store_contact_number,
      'store_alternet_contact_number': instance.store_alternet_contact_number,
      'store_whatsapp_number': instance.store_whatsapp_number,
      'store_email': instance.store_email,
      'store_type': instance.store_type,
      'store_size_area': instance.store_size_area,
      'store_state_id': instance.store_state_id,
      'remarks': instance.remarks,
      'create_date_time': instance.create_date_time,
    };
