

import '../../database/store_entity.dart';

class StoreResponse {
  final String status;
  final String message;
  final List<StoreEntity> storeList;

  StoreResponse({
    required this.status,
    required this.message,
    required this.storeList,
  });

  factory StoreResponse.fromJson(Map<String,dynamic> json){
    return StoreResponse(
        status : json['status'] as String,
        message : json['message'] as String,
        storeList : (json['store_list'] as List)
            .map((item) => StoreEntity.fromJson(item)).toList()
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'status': status,
      'message': message,
      'store_list': storeList.map((item)=> item.toJson()).toList()
    };
  }

}