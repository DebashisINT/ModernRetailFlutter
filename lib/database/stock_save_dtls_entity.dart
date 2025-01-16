import 'package:floor/floor.dart';

@Entity(tableName: "mr_stock_dtls_save")
class StockSaveDtlsEntity{
  @PrimaryKey(autoGenerate: true)
  int? sl_no;
  String stock_id;
  int product_dtls_id;
  String product_id;
  int qty;
  int uom_id;
  String uom;
  String mfg_date;
  String expire_date;

  StockSaveDtlsEntity({this.sl_no,this.stock_id="",this.product_dtls_id=0,this.product_id="", this.qty=0,
     this.uom_id=0, this.uom="", this.mfg_date="", this.expire_date=""});

  factory StockSaveDtlsEntity.fromJson(Map<String,dynamic> json){
    return StockSaveDtlsEntity(
        sl_no: json['sl_no'],stock_id: json['stock_id'],product_dtls_id: json['product_dtls_id'],product_id: json['product_id'],qty: json['qty'],
        uom_id: json['uom_id'],uom: json['uom'],mfg_date: json['mfg_date'],expire_date: json['expire_date']);
  }

  Map<String,dynamic> toJson(){
    return{
      'stock_id':stock_id,
      'product_dtls_id':product_dtls_id,
      'product_id':product_id,
      'qty':qty,
      'uom_id':uom_id,
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