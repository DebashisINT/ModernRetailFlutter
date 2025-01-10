import 'package:floor/floor.dart';

@Entity(tableName: 'mr_state_pin')
class StatePinEntity{
  @PrimaryKey(autoGenerate: false)
  final int pin_id;
  final String pincode;
  final int city_id;
  final String city_name;
  final int state_id;
  final String state_name;


  StatePinEntity({required this.pin_id,required this.pincode,required this.city_id,
    required this.city_name,required this.state_id,required this.state_name});

  factory StatePinEntity.fromJson(Map<String, dynamic> json) {
    return StatePinEntity(
      pin_id: json['pin_id'],pincode: json['pincode'],city_id: json['city_id'] ,
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

@dao
abstract class StatePinDao{
  @Query('select * from mr_state_pin')
  Future<List<StatePinEntity>> getAll();

  @Query('delete from mr_state_pin')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<StatePinEntity> list);

  @Query('SELECT state_id FROM mr_state_pin WHERE pincode = :pincode')
  Future<int?> getStateIDByPincode(String pincode);
}