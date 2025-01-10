import 'package:floor/floor.dart';

@Entity(tableName: "mr_stock_dtls_save")
class StockSaveDtlsEntity{
  @PrimaryKey(autoGenerate: true)
  final int? sl_no;
  final String stock_id;
  final String product_id;
  final String qty;
  final String uom;
  final String mfg_date;
  final String expire_date;

  StockSaveDtlsEntity({this.sl_no,required this.stock_id,required this.product_id,required this.qty,
    required this.uom,required this.mfg_date,required this.expire_date});

  factory StockSaveDtlsEntity.fromJson(Map<String,dynamic> json){
    return StockSaveDtlsEntity(
        sl_no: json['sl_no'],stock_id: json['stock_id'],product_id: json['product_id'],qty: json['qty'],
        uom: json['uom'],mfg_date: json['mfg_date'],expire_date: json['expire_date']);
  }

  Map<String,dynamic> toJson(){
    return{
      'stock_id':stock_id,
      'product_id':product_id,
      'qty':qty,
      'uom':uom,
      'mfg_date':mfg_date,
      'expire_date':expire_date,
    };
  }
}

@dao
abstract class StockSaveDtlsDao{
  @Query('select * from mr_stock_dtls_save')
  Future<List<StockSaveDtlsEntity>> getAll();

  @Query('delete from mr_stock_dtls_save')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<StockSaveDtlsEntity> list);
}