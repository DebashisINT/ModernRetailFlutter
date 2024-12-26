import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/store_entity.dart';

@dao
abstract class StoreDao{
  @Query('select * from store')
  Future<List<StoreEntity>> getAll();

  @insert
  Future<void> insertStore(StoreEntity obj);

  @Query('SELECT * FROM store LIMIT :limit OFFSET :offset')
  Future<List<StoreEntity>> getStorePagination(int limit, int offset);
}