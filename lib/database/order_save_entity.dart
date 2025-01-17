import 'package:floor/floor.dart';

@Entity(tableName: 'mr_order_save')
class OrderSaveEntity{
  @PrimaryKey(autoGenerate: false)
  String order_id;
  String store_id;
  String order_date_time;
  String order_amount;
  String order_status;
  String remarks;

  OrderSaveEntity({this.order_id="", this.store_id="", this.order_date_time="", this.order_amount="", this.order_status="",this.remarks=""});

  factory OrderSaveEntity.fromJson(Map<String, dynamic> json) {
    return OrderSaveEntity(
        order_id: json['order_id'],store_id: json['store_id'],order_date_time: json['order_date_time'] ,
        order_amount: json['order_amount'],order_status: json['order_status'], remarks: json['remarks']);
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': order_id,
      'store_id': store_id,
      'order_date_time': order_date_time,
      'order_amount': order_amount,
      'order_status': order_status,
      'remarks': remarks
    };
  }
}

@dao
abstract class OrderSaveDao{
  @Query('select * from mr_order_save')
  Future<List<OrderSaveEntity>> getAll();

  @Query('delete from mr_order_save')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(OrderSaveEntity obj);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<OrderSaveEntity> list);

  @Query('SELECT * FROM mr_order_save ORDER BY order_date_time ASC LIMIT :limit OFFSET :offset')
  Future<List<OrderSaveEntity>> fetchPaginatedItems(int limit, int offset);

  @Query('delete from mr_order_save where order_id=:order_id ')
  Future<void> deleteById(String order_id);

}