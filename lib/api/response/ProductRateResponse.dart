
import 'package:fl/database/product_rate_entity.dart';

class ProductRateResponse{
  final String status;
  final String message;
  final List<ProductRateEntity> productList;

  ProductRateResponse({
    required this.status,
    required this.message,
    required this.productList,
  });

  factory ProductRateResponse.fromJson(Map<String,dynamic> json){
    return ProductRateResponse(
        status : json['status'] as String,
        message : json['message'] as String,
        productList : (json['product_rate_list'] as List)
            .map((item) => ProductRateEntity.fromJson(item)).toList()
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'status': status,
      'message': message,
      'product_rate_list': productList.map((item)=> item.toJson()).toList()
    };
  }
}