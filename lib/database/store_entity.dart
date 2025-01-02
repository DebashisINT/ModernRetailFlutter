import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store_entity.g.dart';

@Entity(tableName: 'store')
@JsonSerializable()
class StoreEntity {
  @PrimaryKey(autoGenerate: false)
  @JsonKey(name: "store_id")
  final String store_id;

  @JsonKey(name: "store_name")
  final String store_name;

  @JsonKey(name: "store_address")
  final String store_address;

  @JsonKey(name: "store_pincode")
  final String store_pincode;

  @JsonKey(name: "store_lat")
  final String store_lat;

  @JsonKey(name: "store_long")
  final String store_long;

  @JsonKey(name: "store_contact_name")
  final String store_contact_name;

  @JsonKey(name: "store_contact_number")
  final String store_contact_number;

  @JsonKey(name: "store_alternet_contact_number")
  final String store_alternet_contact_number;

  @JsonKey(name: "store_whatsapp_number")
  final String store_whatsapp_number;

  @JsonKey(name: "store_email")
  final String store_email;

  @JsonKey(name: "store_type")
  final String store_type;

  @JsonKey(name: "store_size_area")
  final String store_size_area;

  @JsonKey(name: "store_state_id")
  final String store_state_id;

  @JsonKey(name: "remarks")
  final String remarks;

  @JsonKey(name: "create_date_time")
  final String create_date_time;

/*  @JsonKey(name: "store_pic_url")
  final String store_pic_url;*/

/*  @JsonKey(name: "isUploaded")
  final bool isUploaded;*/

  StoreEntity({
    required this.store_id,
    required this.store_name,
    required this.store_address,
    required this.store_pincode,
    required this.store_lat,
    required this.store_long,
    required this.store_contact_name,
    required this.store_contact_number,
    required this.store_alternet_contact_number,
    required this.store_whatsapp_number,
    required this.store_email,
    required this.store_type,
    required this.store_size_area,
    required this.store_state_id,
    required this.remarks,
    required this.create_date_time
/*
    required this.store_pic_url,
*/
    /*required this.isUploaded*/
  });

  factory StoreEntity.fromJson(Map<String, dynamic> json) =>
      _$StoreEntityFromJson(json);

  Map<String, dynamic> toJson() => _$StoreEntityToJson(this);
}
