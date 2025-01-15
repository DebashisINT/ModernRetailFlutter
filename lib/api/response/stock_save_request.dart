import 'package:json_annotation/json_annotation.dart';
import 'package:modern_retail/database/stock_save_dtls_entity.dart';

part 'stock_save_request.g.dart';

@JsonSerializable()
class StockSaveRequest{
  final String user_id;
  final String stock_id;
  final String save_date_time;
  final String store_id;
  final List<StockSaveDtlsEntity> product_list;

  StockSaveRequest({
    required this.user_id,
    required this.stock_id,
    required this.save_date_time,
    required this.store_id,
    required this.product_list,
  });

  factory StockSaveRequest.fromJson(Map<String, dynamic> json) => _$StockSaveRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StockSaveRequestToJson(this);

}