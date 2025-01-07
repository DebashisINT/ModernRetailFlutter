import 'package:floor/floor.dart';

@Entity(tableName: 'mr_stock_product')
class StockProductEntity{
  @PrimaryKey(autoGenerate: false)
  final int sl_no;
  final int product_id;
  final String product_name;
  final String product_description;
  final int brand_id;
  final String brand_name;
  final int category_id;
  final String category_name;
  final int watt_id;
  final String watt_name;
  final double product_mrp;
  final String UOM;
  final String product_pic_url;
  final String qty;
  final String mfgDate;
  final String expDate;


  StockProductEntity({this.sl_no=0,this.product_id=0,this.product_name="", this.product_description="", this.brand_id=0,
    this.brand_name="", this.category_id=0, this.category_name="", this.watt_id=0, this.watt_name="",
    this.product_mrp=0.0, this.UOM="", this.product_pic_url="",this.qty="",this.mfgDate="",this.expDate=""});
}

@dao
abstract class StockProductDao{
  @Query('select * from mr_stock_product')
  Future<List<StockProductEntity>> getAll();

  @Query('delete from mr_stock_product')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<StockProductEntity> list);

  @Query(''' insert into mr_stock_product (sl_no,product_id,product_name,product_description,
    brand_id,brand_name,category_id,category_name,watt_id,watt_name,product_mrp,UOM,
    product_pic_url,qty,mfgDate,expDate)
select (SELECT COUNT(*) + 1 + ROWID FROM mr_stock_product) AS sl_no,PR.product_id,PR.product_name,
PR.product_description,PR.brand_id,PR.brand_name,PR.category_id,PR.category_name,PR.watt_id,
PR.watt_name,PR.product_mrp,PR.uom,PR.product_pic_url,'' as qty,'' as mfgDate,'' as expDate
from mr_product as PR ''')
  Future<void> setData();

  @Query('update mr_stock_product set sl_no = sl_no - 1')
  Future<void> setSlNo();


  @Query('SELECT * FROM mr_stock_product WHERE product_name LIKE :query LIMIT :limit OFFSET :offset')
  Future<List<StockProductEntity>> fetchPaginatedItemsSearch(String query, int limit, int offset,);

}