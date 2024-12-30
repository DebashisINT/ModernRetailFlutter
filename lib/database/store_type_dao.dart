import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/store_type_entity.dart';

@dao
abstract class StoreTypeDao{
  @Query('select * from store_type')
  Future<List<StoreTypeEntity>> getAll();

  @insert
  Future<void> insertStoreType(StoreTypeEntity obj);

  @Query('SELECT type_name FROM store_type WHERE type_id = :type_id')
  Future<String?> getStoreTypeById(String type_id);
}