class ProductResponse{
  final String status;
  final String message;
  final List<Product> productList;

  ProductResponse({
    required this.status,
    required this.message,
    required this.productList,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      productList: (json['product_rate_list'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'product_rate_list': productList.map((item) => item.toJson()).toList(),
    };
  }

}

class Product {
  final int product_id;
  final int state_id;
  final double rate;

  Product({
    required this.product_id,
    required this.state_id,
    required this.rate
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json['product_id'] as int,
      state_id: json['state_id'] as int,
      rate: json['rate'] as double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product_id,
      'state_id': state_id,
      'rate': rate
    };
  }
}