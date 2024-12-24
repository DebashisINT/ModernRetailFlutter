import 'package:floor/floor.dart';

@Entity(tableName: 'store')
class StoreEntity{
  @PrimaryKey(autoGenerate: false)
  final String store_id;
  final String store_name;
  final String store_address;
  final String store_pincode;
  final String store_lat;
  final String store_long;
  final String store_contact_name;
  final String store_contact_number;
  final String store_alternet_contact_number;
  final String store_whatsapp_number;
  final String store_email;
  final String store_type;
  final String store_size_area;
  final String store_state_id;
  final String remarks;
  final String create_date_time;
  final String store_pic_url;
  final bool isUploaded;

  StoreEntity({required this.store_id,required this.store_name,required this.store_address,required this.store_pincode,
    required this.store_lat,required this.store_long,required this.store_contact_name,required this.store_contact_number,
    required this.store_alternet_contact_number,required this.store_whatsapp_number,required this.store_email,required this.store_type,
    required this.store_size_area,required this.store_state_id,required this.remarks,required this.create_date_time,
    required this.store_pic_url,required this.isUploaded});


}