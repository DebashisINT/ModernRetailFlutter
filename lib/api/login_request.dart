class LoginRequest{
  String? user_id;

  LoginRequest({this.user_id,});

  LoginRequest.fromJson(dynamic json){
    user_id = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = user_id;
    return map;
  }
}