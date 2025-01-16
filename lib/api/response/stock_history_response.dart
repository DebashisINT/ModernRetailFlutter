

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
  String stockId;
  int productDtlsId;
  int productId;
  double qty;
  int uomId;
  String uom;
  String mfgDate;
  String expireDate;

  Product({
    required this.stockId,
    required this.productDtlsId,
    required this.productId,
    required this.qty,
    required this.uomId,
    required this.uom,
    required this.mfgDate,
    required this.expireDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      stockId: json['stock_id'],
      productDtlsId: json['product_dtls_id'],
      productId: json['product_id'],
      qty: (json['qty'] as num).toDouble(),
      uomId: json['uom_id'],
      uom: json['uom'],
      mfgDate: json['mfg_date'],
      expireDate: json['expire_date'],
    );
  }
}