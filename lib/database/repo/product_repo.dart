import 'package:flutter_demo_one/database/product_dao.dart';
import 'package:flutter_demo_one/database/product_entity.dart';

class ProductRepo {
  final ProductDao productDao; // Your DAO instance

  ProductRepo(this.productDao);

  Future<List<ProductEntity>> getPaginatedItems(int page, int pageSize) async {
    final offset = (page - 1) * pageSize;
    return await productDao.getProductPagination(pageSize, offset);
  }
}