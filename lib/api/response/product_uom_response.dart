

import 'package:modern_retail/database/product_uom.dart';

class ProductUOMResponse{
  final String status;
  final String message;
  final List<ProductUOMEntity> uomList;

  ProductUOMResponse({
    required this.status,
    required this.message,
    required this.uomList,
  });

  factory ProductUOMResponse.fromJson(Map<String,dynamic> json){
    return ProductUOMResponse(
        status : json['status'] as String,
        message : json['message'] as String,
        uomList : (json['uom_list'] as List)
            .map((item) => ProductUOMEntity.fromJson(item)).toList()
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'status': status,
      'message': message,
      'uom_list': uomList.map((item)=> item.toJson()).toList()
    };
  }
}