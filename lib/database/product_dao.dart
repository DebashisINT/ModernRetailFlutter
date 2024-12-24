import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/product_entity.dart';

@dao
abstract class ProductDao{
  @Query('select * from product')
  Future<List<ProductEntity>> getAll();

  @insert
  Future<void> insertProduct(ProductEntity obj);
}