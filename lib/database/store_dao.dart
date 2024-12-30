import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/store_entity.dart';

@dao
abstract class StoreDao {
  @Query('SELECT * FROM store')
  Future<List<StoreEntity>> getAll();

  @insert
  Future<void> insertStore(StoreEntity obj);

  // Correctly add the @update annotation to updateStore
  @update
  Future<void> updateStore(StoreEntity updatedStore);

  // Update to return a nullable StoreEntity in case the store is not found
  @Query('SELECT * FROM store WHERE store_id = :store_id')
  Future<StoreEntity?> getStoreById(String store_id);

  @Query('SELECT * FROM store LIMIT :limit OFFSET :offset')
  Future<List<StoreEntity>> getStorePagination(int limit, int offset);
}
