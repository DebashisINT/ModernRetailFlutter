import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/store_entity.dart';

@dao
abstract class StoreDao{
  @Query('select * from store')
  Future<List<StoreEntity>> getAll();

  @insert
  Future<void> insertStoreType(StoreEntity obj);
}