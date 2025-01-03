class LoginResponse{
  final String status;
  final String message;
  final String user_name;
  final String user_id;
  final String contact_number;
  final String email;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final String address;
  final String profile_pic_url;


  LoginResponse({
    required this.status,
    required this.message,
    required this.user_name,
    required this.user_id,
    required this.contact_number,
    required this.email,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.address,
    required this.profile_pic_url,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        status: json['status'] as String,
        message: json['message'] as String,
        user_name: json['user_name'] as String,
        user_id: json['user_id'] as String,
        contact_number: json['contact_number'] as String,
        email: json['email'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        country: json['country'] as String,
        pincode: json['pincode'] as String,
        address: json['address'] as String,
        profile_pic_url: json['profile_pic_url'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'user_name': user_name,
      'user_id': user_id,
      'contact_number': contact_number,
      'email': email,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'address': address,
      'profile_pic_url': profile_pic_url,
    };
  }
}

