import 'package:fl/database/store_type_entity.dart';

class StoreTypeResponse {
  final String status;
  final String message;
  final List<StoreTypeEntity> storeTypeList;

  StoreTypeResponse({
    required this.status,
    required this.message,
    required this.storeTypeList,
  });

  factory StoreTypeResponse.fromJson(Map<String,dynamic> json){
    return StoreTypeResponse(
      status : json['status'] as String,
      message : json['message'] as String,
      storeTypeList : (json['store_type_list'] as List)
          .map((item) => StoreTypeEntity.fromJson(item)).toList()
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'status': status,
      'message': message,
      'store_type_list': storeTypeList.map((item)=> item.toJson()).toList()
    };
  }

}