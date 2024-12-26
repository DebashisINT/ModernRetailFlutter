import 'package:floor/floor.dart';

@Entity(tableName: 'state_pin')
class StatePinEntity{
  @PrimaryKey(autoGenerate: true)
  final int? sl_no;
  final int pin_id;
  final String pincode;
  final int city_id;
  final String city_name;
  final int state_id;
  final String state_name;

  StatePinEntity({this.sl_no,required this.pin_id,required this.pincode,required this.city_id,
    required this.city_name,required this.state_id,required this.state_name});

  factory StatePinEntity.fromJson(Map<String, dynamic> json) {
    return StatePinEntity(
        sl_no: json['sl_no'],pin_id: json['pin_id'],pincode: json['pincode'],city_id: json['city_id'] ,
      city_name: json['city_name'],state_id: json['state_id'],state_name: json['state_name'] ,// Map JSON properties to StoreTypeEntity fields
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pin_id': pin_id,
      'pincode': pincode,
      'city_id': city_id,
      'city_name': city_name,
      'state_id': state_id,
      'state_name': state_name
    };
  }
}