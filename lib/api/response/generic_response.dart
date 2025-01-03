class GenericResponse{
  final String status;
  final String message;

  GenericResponse({
    required this.status,
    required this.message,
  });

  factory GenericResponse.fromJson(Map<String, dynamic> json) {
    return GenericResponse(
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

