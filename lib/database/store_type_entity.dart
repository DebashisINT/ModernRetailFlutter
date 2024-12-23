import 'package:floor/floor.dart';

@Entity(tableName: 'store_type')
class StoreTypeEntity{
  @PrimaryKey(autoGenerate: false)
  final int type_id;
  final String type_name;

  StoreTypeEntity({required this.type_id,required this.type_name});

  factory StoreTypeEntity.fromJson(Map<String, dynamic> json) {
    return StoreTypeEntity(
        type_id: json['type_id'],type_name: json['type_name'],  // Map JSON properties to StoreTypeEntity fields
    );
  }
}