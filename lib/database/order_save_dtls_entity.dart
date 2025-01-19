import 'package:floor/floor.dart';

@Entity(tableName: 'mr_order_save_dtls')
class OrderSaveDtlsEntity{
  @PrimaryKey(autoGenerate: true)
  int? sl_no;
  String order_id;
  int product_id;
  String product_name;
  double qty;
  double rate;

  OrderSaveDtlsEntity({this.sl_no,this.order_id="", this.product_id=0,this.product_name="", this.qty=0.0, this.rate=0.0});

  factory OrderSaveDtlsEntity.fromJson(Map<String, dynamic> json) {
    return OrderSaveDtlsEntity(
        sl_no: json['sl_no'],order_id: json['order_id'],product_id: json['product_id'],product_name: json['product_name'],
        qty: json['qty'],rate: json['rate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': order_id,
      'product_id': product_id,
      'product_name': product_name,
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

  @Query('delete from mr_order_save_dtls where order_id=:order_id ')
  Future<void> deleteById(String order_id);

  @Query('select * from mr_order_save_dtls where order_id=:order_id')
  Future<List<OrderSaveDtlsEntity>> getDtlsById(String order_id);

  @Query('SELECT * FROM mr_order_save_dtls where order_id=:order_id LIMIT :limit OFFSET :offset')
  Future<List<OrderSaveDtlsEntity>> fetchPaginatedItemsForOrder(String order_id,int limit, int offset);
}