import 'package:floor/floor.dart';

@Entity(tableName: 'mr_product')
class ProductEntity{
  @PrimaryKey(autoGenerate: false)
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


  ProductEntity({this.product_id=0,this.product_name="", this.product_description="", this.brand_id=0,
     this.brand_name="", this.category_id=0, this.category_name="", this.watt_id=0, this.watt_name="",
     this.product_mrp=0.0, this.UOM="", this.product_pic_url=""});

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      product_id: json['product_id'],product_name: json['product_name'],product_description: json['product_description'] ,
        brand_id: json['brand_id'],brand_name: json['brand_name'],category_id: json['category_id'],category_name: json['category_name'],
        watt_id: json['watt_id'],watt_name: json['watt_name'],product_mrp: json['product_mrp'],UOM: json['UOM'],product_pic_url: json['product_pic_url']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product_id,
      'product_name': product_name,
      'product_description': product_description,
      'brand_id': brand_id,
      'brand_name': brand_name,
      'category_id': category_id,
      'category_name': category_name,
      'watt_id': watt_id,
      'watt_name': watt_name,
      'product_mrp': product_mrp,
      'UOM': UOM,
      'product_pic_url': product_pic_url,
    };
  }
}

@dao
abstract class ProductDao{
  @Query('select * from mr_product')
  Future<List<ProductEntity>> getAll();

  @Query('delete from mr_product')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<ProductEntity> list);

  @Query('SELECT * FROM mr_product ORDER BY product_id ASC LIMIT :limit OFFSET :offset')
  Future<List<ProductEntity>> fetchPaginatedItems(int limit, int offset);

  @Query('SELECT * FROM mr_product WHERE product_name LIKE :query LIMIT :limit OFFSET :offset')
  Future<List<ProductEntity>> fetchPaginatedItemsSearch(String query, int limit, int offset,);
}