import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/product_entity.dart';

@dao
abstract class ProductDao{
  @Query('select * from product')
  Future<List<ProductEntity>> getAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertProductAll(List<ProductEntity> obj);

  @Query('SELECT * FROM product LIMIT :limit OFFSET :offset')
  Future<List<ProductEntity>> getProductPagination(int limit, int offset);

}