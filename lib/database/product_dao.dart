import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/product_entity.dart';

@dao
abstract class ProductRateDao{
  @Query('select * from product_rate')
  Future<List<ProductRateEntity>> getAll();

  @insert
  Future<void> insertProduct(ProductRateEntity obj);
}