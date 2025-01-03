import 'package:floor/floor.dart';

@Entity(tableName: "mr_store_type")
class StoreTypeEntity{
  @PrimaryKey(autoGenerate: false)
  final int type_id;
  final String type_name;

  StoreTypeEntity({ this.type_id=0, this.type_name=""});

  factory StoreTypeEntity.fromJson(Map<String,dynamic> json){
    return StoreTypeEntity(
        type_id: json['type_id'],type_name: json['type_name']
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'type_id':type_id,
      'type_name':type_name
    };
  }
}

@dao
abstract class StoreTypeDao{
  @Query('select * from mr_store_type')
  Future<List<StoreTypeEntity>> getAll();

  @Query('delete from mr_store_type')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<StoreTypeEntity> list);

  @Query('SELECT type_name FROM mr_store_type WHERE type_id = :type_id')
  Future<String?> getStoreTypeById(String type_id);

  @Query('SELECT * FROM mr_store_type WHERE type_id = :type_id')
  Future<StoreTypeEntity?> getStoreTypeDtls(String type_id);
}