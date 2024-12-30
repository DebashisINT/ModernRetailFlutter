

import 'package:floor/floor.dart';

@Entity(tableName: 'product')
class ProductEntity{
  @PrimaryKey(autoGenerate: true)
  final int? sl_no;
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

  ProductEntity({this.sl_no, required this.product_id, required this.product_name, required this.product_description, required this.brand_id, required this.brand_name, required this.category_id,
    required this.category_name, required this.watt_id, required this.watt_name, required this.product_mrp, required this.UOM, required this.product_pic_url});

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
        sl_no: json['sl_no'],product_id: json['product_id'],product_name: json['product_name'],product_description: json['product_description'] ,
        brand_id: json['brand_id'],brand_name: json['brand_name'],category_id: json['category_id'],category_name: json['category_name'],
        watt_id: json['watt_id'],watt_name: json['watt_name'],product_mrp: json['product_mrp'],UOM: json['UOM'],product_pic_url: json['product_pic_url'],
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