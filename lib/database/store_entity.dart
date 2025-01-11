import 'package:floor/floor.dart';

@Entity(tableName: "mr_store")
class StoreEntity{
  @PrimaryKey(autoGenerate: false)
  final String store_id;
  final int branch_id;
  final String store_name;
  final String store_address;
  final String store_pincode;
  final String? store_lat;
  final String? store_long;
  final String store_contact_name;
  final String store_contact_number;
  final String? store_alternet_contact_number;
  final String? store_whatsapp_number;
  final String? store_email;
  final int store_type;
  final String? store_size_area;
  final int store_state_id;
  final String? remarks;
  final String? create_date_time;
  final String store_pic_url;
  final bool isUploaded;

  StoreEntity({this.store_id="",this.branch_id=0, this.store_name="",this.store_address="", this.store_pincode="",
    this.store_lat="", this.store_long="",this.store_contact_name="", this.store_contact_number="",
    this.store_alternet_contact_number="", this.store_whatsapp_number="",this.store_email="", this.store_type=0,
    this.store_size_area="", this.store_state_id=0,this.remarks="", this.create_date_time="",this.store_pic_url="",
    this.isUploaded = false
  });

  factory StoreEntity.fromJson(Map<String,dynamic> json){
    return StoreEntity(
        store_id: json['store_id'],branch_id: json['branch_id'],store_name: json['store_name'],store_address: json['store_address'],
      store_pincode: json['store_pincode'],store_lat: json['store_lat'],store_long: json['store_long'],
      store_contact_name: json['store_contact_name'],store_contact_number: json['store_contact_number'],
      store_alternet_contact_number: json['store_alternet_contact_number'], store_whatsapp_number: json['store_whatsapp_number'],
      store_email: json['store_email'], store_type: json['store_type'],store_size_area: json['store_size_area'], store_state_id: json['store_state_id'],
      remarks: json['remarks'], create_date_time: json['create_date_time'],store_pic_url: json['store_pic_url']
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'store_id':store_id,
      'branch_id':branch_id,
      'store_name':store_name,
      'store_address':store_address,
      'store_pincode':store_pincode,
      'store_lat':store_lat,
      'store_long':store_long,
      'store_contact_name':store_contact_name,
      'store_contact_number':store_contact_number,
      'store_alternet_contact_number':store_alternet_contact_number,
      'store_whatsapp_number':store_whatsapp_number,
      'store_email':store_email,
      'store_type':store_type,
      'store_size_area':store_size_area,
      'store_state_id':store_state_id,
      'remarks':remarks,
      'create_date_time':create_date_time,
      'store_pic_url':store_pic_url,
    };
  }
}

@dao
abstract class StoreDao{
  @Query('select * from mr_store')
  Future<List<StoreEntity>> getAll();

  @Query('delete from mr_store')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStore(StoreEntity obj);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<StoreEntity> list);

  @Query('SELECT * FROM mr_store LIMIT :limit OFFSET :offset')
  Future<List<StoreEntity>> fetchPaginatedItems(int limit, int offset);

  @Query('SELECT * FROM mr_store WHERE store_name LIKE :query LIMIT :limit OFFSET :offset')
  Future<List<StoreEntity>> fetchPaginatedItemsSearch(String query, int limit, int offset,);
}