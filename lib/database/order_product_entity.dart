import 'dart:ffi';

import 'package:floor/floor.dart';

@Entity(tableName: 'mr_order_product')
class OrderProductEntity {
  @PrimaryKey(autoGenerate: false)
  int sl_no;
  int product_id;
  String product_name;
  String product_description;
  int brand_id;
  String brand_name;
  int category_id;
  String category_name;
  int watt_id;
  String watt_name;
  double product_mrp;
  String UOM;
  String product_pic_url;
  int state_id;
  int qty;
  double rate;
  bool isAdded = false;

  OrderProductEntity({this.sl_no = 0, this.product_id = 0, this.product_name = "", this.product_description = "", this.brand_id = 0,
    this.brand_name = "", this.category_id = 0, this.category_name = "", this.watt_id = 0, this.watt_name = "",
    this.product_mrp = 0.0, this.UOM = "", this.product_pic_url = "", this.state_id = 0, this.qty = 0, this.rate = 0.0, this.isAdded = false});
}

@dao
abstract class OrderProductDao {
  @Query('select * from mr_order_product')
  Future<List<OrderProductEntity>> getAll();

  @Query('select * from mr_order_product where isAdded=1')
  Future<List<OrderProductEntity>> getAllAdded();

  @Query('delete from mr_order_product')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<OrderProductEntity> list);

  @Query(''' insert into mr_order_product (sl_no,product_id,product_name,product_description,
    brand_id,brand_name,category_id,category_name,watt_id,watt_name,product_mrp,UOM,
    product_pic_url,state_id,qty,rate,isAdded)
  select (SELECT COUNT(*) + 1 + ROWID FROM mr_order_product) AS sl_no,
  P.product_id,P.product_name,P.product_description,P.brand_id,P.brand_name,
  P.category_id,P.category_name,P.watt_id,P.watt_name,P.product_mrp,P.uom,P.product_pic_url,
  COALESCE(R.state_id,null,0) as state_id,0 as qty,COALESCE(R.rate,null,0.0) as rate,
  0 as isAdded
  from mr_product as P
  left join mr_product_rate as R on P.product_id = R.product_id ''')
  Future<void> setData();

  @Query('update mr_order_product set sl_no = sl_no - 1')
  Future<void> setSlNo();

  @Query('update mr_order_product set qty =:qty ,rate=:rate ,isAdded=:isAdded where product_id=:product_id')
  Future<void> updateAdded(int qty,double rate,bool isAdded,int product_id);

  @Query('select COALESCE(sum(qty * rate), 0.0) as totalAmt from mr_order_product where isAdded = 1')
  Future<double?> getTotalAmt();

  @Query('SELECT * FROM mr_order_product WHERE product_name LIKE :query LIMIT :limit OFFSET :offset')
  Future<List<OrderProductEntity>> fetchPaginatedItemsSearch(String query, int limit, int offset);

  @Query('SELECT * FROM mr_order_product LIMIT :limit OFFSET :offset')
  Future<List<OrderProductEntity>> fetchPaginatedItems(int limit, int offset);

  @Query('SELECT * FROM mr_order_product where isAdded=1 LIMIT :limit OFFSET :offset')
  Future<List<OrderProductEntity>> fetchPaginatedItemsAdded(int limit, int offset);

  @Query('select count(*)As count from mr_order_product WHERE isAdded=1')
  Future<int?> getProductAddedCount();

}
