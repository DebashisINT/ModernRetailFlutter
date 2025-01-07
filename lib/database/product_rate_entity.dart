import 'package:floor/floor.dart';

@Entity(tableName: 'mr_product_rate')
class ProductRateEntity{
  @PrimaryKey(autoGenerate: false)
  final int product_id;
  final int state_id;
  final double rate;

  ProductRateEntity({this.product_id=0,this.state_id=0, this.rate=0.0});

  factory ProductRateEntity.fromJson(Map<String, dynamic> json) {
    return ProductRateEntity(
        product_id: json['product_id'],state_id: json['state_id'],rate: json['rate']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product_id,
      'state_id': state_id,
      'rate': rate,
    };
  }
}

@dao
abstract class ProductRateDao{
  @Query('select * from mr_product_rate')
  Future<List<ProductRateEntity>> getAll();

  @Query('delete from mr_product_rate')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<ProductRateEntity> list);

}