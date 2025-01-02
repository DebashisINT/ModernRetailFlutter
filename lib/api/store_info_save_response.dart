class StoreInfoSaveResponse{
  final String status;
  final String message;

  StoreInfoSaveResponse({
    required this.status,
    required this.message,
  });

  factory StoreInfoSaveResponse.fromJson(Map<String, dynamic> json) {
    return StoreInfoSaveResponse(
      status: json['status'] as String,
      message: json['message'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message
    };
  }

}

