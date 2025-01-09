
import '../../database/product_entity.dart';

class ProductResponse{
  final String status;
  final String message;
  final List<ProductEntity> productList;

  ProductResponse({
    required this.status,
    required this.message,
    required this.productList,
  });

  factory ProductResponse.fromJson(Map<String,dynamic> json){
    return ProductResponse(
        status : json['status'] as String,
        message : json['message'] as String,
        productList : (json['product_list'] as List)
            .map((item) => ProductEntity.fromJson(item)).toList()
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'status': status,
      'message': message,
      'product_list': productList.map((item)=> item.toJson()).toList()
    };
  }
}