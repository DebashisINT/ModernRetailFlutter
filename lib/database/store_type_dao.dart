import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/store_type_entity.dart';

@dao
abstract class StoreTypeDao{
  @Query('select * from store_type')
  Future<List<StoreTypeEntity>> getAll();

  @insert
  Future<void> insertStoreType(StoreTypeEntity obj);
}