

class OrderHistoryResponse{
  final String status;
  final String message;
  final List<Order> orderList;

  OrderHistoryResponse({
    required this.status,
    required this.message,
    required this.orderList,
  });

  factory OrderHistoryResponse.fromJson(Map<String,dynamic> json){
    return OrderHistoryResponse(
        status : json['status'] as String,
        message : json['message'] as String,
        orderList : (json['order_list'] as List)
            .map((item) => Order.fromJson(item)).toList()
    );
  }
}

class Order {
  String store_id;
  String order_id;
  String order_date_time;
  String order_amount;
  String order_status;
  String remarks;
  List<OrderDtls> order_details_list;

  Order({
    required this.store_id,
    required this.order_id,
    required this.order_date_time,
    required this.order_amount,
    required this.order_status,
    required this.remarks,
    required this.order_details_list,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      store_id: json['store_id'],
      order_id: json['order_id'],
      order_date_time: json['order_date_time'],
      order_amount: json['order_amount'],
      order_status: json['order_status'],
      remarks: json['remarks'],
      order_details_list: (json['order_details_list'] as List)
          .map((item) => OrderDtls.fromJson(item)).toList(),
    );
  }
}

class OrderDtls {
  String order_id;
  int product_id;
  double qty;
  double rate;

  OrderDtls({
    required this.order_id,
    required this.product_id,
    required this.qty,
    required this.rate
  });

  factory OrderDtls.fromJson(Map<String, dynamic> json) {
    return OrderDtls(
      order_id: json['order_id'],
      product_id: json['product_id'],
      qty: json['qty'],
      rate: (json['rate'] as num).toDouble(),
    );
  }
}