import 'package:floor/floor.dart';

@Entity(tableName: 'product')
class ProductEntity{
  @PrimaryKey(autoGenerate: false)
  final int product_id;
  final int state_id;
  final double rate;

  ProductEntity({required this.product_id,required this.state_id,required this.rate});

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      product_id: json['product_id'],state_id: json['state_id'],rate: json['rate']  // Map JSON properties to StoreTypeEntity fields
    );
  }
}