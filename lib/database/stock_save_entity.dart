import 'package:floor/floor.dart';

@Entity(tableName: "mr_stock_save")
class StockSaveEntity{
  @PrimaryKey(autoGenerate: false)
  String stock_id;
  String save_date_time;
  String store_id;

  StockSaveEntity({this.stock_id="",this.save_date_time="",this.store_id=""});

  factory StockSaveEntity.fromJson(Map<String,dynamic> json){
    return StockSaveEntity(
        stock_id: json['stock_id'],save_date_time: json['save_date_time'],store_id: json['store_id']
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'stock_id':stock_id,
      'save_date_time':save_date_time,
      'store_id':store_id,
    };
  }
}

@dao
abstract class StockSaveDao{
  @Query('select * from mr_stock_save')
  Future<List<StockSaveEntity>> getAll();

  @Query('delete from mr_stock_save')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStock(StockSaveEntity obj);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<StockSaveEntity> list);
}