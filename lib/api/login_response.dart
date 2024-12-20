

import 'package:flutter_demo_one/database/store_type_entity.dart';

class LoginResponse {
  String? status;
  String? message;
  List<StoreTypeEntity>? store_type_list;

  LoginResponse({this.status,this.message});

  LoginResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    store_type_list = json['store_type_list'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['store_type_list'] = store_type_list;
    return map;
  }

}