import 'package:fl/database/state_pin_entity.dart';

class StatePinResponse{
  final String status;
  final String message;
  final List<StatePinEntity> statePinList;

  StatePinResponse({
    required this.status,
    required this.message,
    required this.statePinList,
  });

  factory StatePinResponse.fromJson(Map<String,dynamic> json){
    return StatePinResponse(
        status : json['status'] as String,
        message : json['message'] as String,
        statePinList : (json['pin_state_list'] as List)
            .map((item) => StatePinEntity.fromJson(item)).toList()
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'status': status,
      'message': message,
      'pin_state_list': statePinList.map((item)=> item.toJson()).toList()
    };
  }
}