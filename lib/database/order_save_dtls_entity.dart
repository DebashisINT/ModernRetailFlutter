import 'package:floor/floor.dart';

@Entity(tableName: 'mr_order_save_dtls')
class OrderSaveDtlsEntity{
  @PrimaryKey(autoGenerate: true)
  int? sl_no;
  String order_id;
  String product_id;
  String qty;
  String rate;

  OrderSaveDtlsEntity({this.sl_no,this.order_id="", this.product_id="", this.qty="", this.rate=""});

  factory OrderSaveDtlsEntity.fromJson(Map<String, dynamic> json) {
    return OrderSaveDtlsEntity(
        sl_no: json['sl_no'],order_id: json['order_id'],product_id: json['product_id'] ,
        qty: json['qty'],rate: json['rate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': order_id,
      'product_id': product_id,
      'qty': qty,
      'rate': rate
    };
  }
}

@dao
abstract class OrderSaveDtlsDao{
  @Query('select * from mr_order_save_dtls')
  Future<List<OrderSaveDtlsEntity>> getAll();

  @Query('delete from mr_order_save_dtls')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(OrderSaveDtlsEntity obj);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<OrderSaveDtlsEntity> list);

  @Query('SELECT * FROM mr_order_save_dtls ORDER BY order_date_time ASC LIMIT :limit OFFSET :offset')
  Future<List<OrderSaveDtlsEntity>> fetchPaginatedItems(int limit, int offset);

  @Query('select count(*) as itemCount from mr_order_save_dtls where mr_order_save_dtls.order_id = :order_id')
  Future<int?> getItemCount(String order_id);

}