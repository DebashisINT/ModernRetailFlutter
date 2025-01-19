import 'package:floor/floor.dart';

@Entity(tableName: 'mr_product_uom')
class ProductUOMEntity{
  @PrimaryKey(autoGenerate: true)
  int? sl_no;
  int product_id;
  int uom_id;
  String uom_name;

  ProductUOMEntity({this.sl_no,this.product_id=0, this.uom_id=0, this.uom_name=""});

  factory ProductUOMEntity.fromJson(Map<String, dynamic> json) {
    return ProductUOMEntity(product_id: json['product_id'],uom_id: json['uom_id'],uom_name: json['uom_name']);
  }

  Map<String, dynamic> toJson() {
    return {'product_id': product_id, 'uom_id': uom_id, 'uom_name': uom_name};
  }
}

@dao
abstract class ProductUOMDao{
  @Query('select * from mr_product_uom')
  Future<List<ProductUOMEntity>> getAll();

  @Query('delete from mr_product_uom')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<ProductUOMEntity> list);
}