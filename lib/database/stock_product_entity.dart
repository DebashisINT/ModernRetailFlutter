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


  @Query('SELECT * FROM mr_stock_product WHERE product_name LIKE :query LIMIT :limit OFFSET :offset')
  Future<List<StockProductEntity>> fetchPaginatedItemsSearch(String query, int limit, int offset,);

}