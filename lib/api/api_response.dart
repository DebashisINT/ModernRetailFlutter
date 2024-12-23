

class ApiResponse {
  final String status;
  final String message;
  final List<StoreType> storeTypeList;

  ApiResponse({
    required this.status,
    required this.message,
    required this.storeTypeList,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      storeTypeList: (json['store_type_list'] as List)
          .map((item) => StoreType.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'store_type_list': storeTypeList.map((item) => item.toJson()).toList(),
    };
  }
}

class StoreType {
  final int typeId;
  final String typeName;

  StoreType({
    required this.typeId,
    required this.typeName,
  });

  factory StoreType.fromJson(Map<String, dynamic> json) {
    return StoreType(
      typeId: json['type_id'] as int,
      typeName: json['type_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type_id': typeId,
      'type_name': typeName,
    };
  }
}
