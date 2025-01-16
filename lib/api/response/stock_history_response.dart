

class StockHistoryResponse{
  final String status;
  final String message;
  final List<Stock> stockList;

  StockHistoryResponse({
    required this.status,
    required this.message,
    required this.stockList,
  });

  factory StockHistoryResponse.fromJson(Map<String,dynamic> json){
    return StockHistoryResponse(
        status : json['status'] as String,
        message : json['message'] as String,
        stockList : (json['stock_list'] as List)
            .map((item) => Stock.fromJson(item)).toList()
    );
  }
}

class Stock {
  String stock_id;
  String save_date_time;
  String store_id;
  List<Product> product_list;

  Stock({
    required this.stock_id,
    required this.save_date_time,
    required this.store_id,
    required this.product_list,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      stock_id: json['stock_id'],
      save_date_time: json['save_date_time'],
      store_id: json['store_id'],
      product_list: (json['product_list'] as List)
          .map((item) => Product.fromJson(item)).toList(),
    );
  }
}

class Product {
  String stock_id;
  int product_dtls_id;
  int product_id;
  double qty;
  int uom_id;
  String uom;
  String mfg_date;
  String expire_date;

  Product({
    required this.stock_id,
    required this.product_dtls_id,
    required this.product_id,
    required this.qty,
    required this.uom_id,
    required this.uom,
    required this.mfg_date,
    required this.expire_date,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      stock_id: json['stock_id'],
      product_dtls_id: json['product_dtls_id'],
      product_id: json['product_id'],
      qty: (json['qty'] as num).toDouble(),
      uom_id: json['uom_id'],
      uom: json['uom'],
      mfg_date: json['mfg_date'],
      expire_date: json['expire_date'],
    );
  }
}