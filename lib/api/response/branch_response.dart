import 'package:modern_retail/database/branch_entity.dart';

class BranchResponse{
  final String status;
  final String message;
  final List<BranchEntity> branchList;

  BranchResponse({
    required this.status,
    required this.message,
    required this.branchList,
  });

  factory BranchResponse.fromJson(Map<String,dynamic> json){
    return BranchResponse(
        status : json['status'] as String,
        message : json['message'] as String,
        branchList : (json['branch_list'] as List)
            .map((item) => BranchEntity.fromJson(item)).toList()
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'status': status,
      'message': message,
      'branch_list': branchList.map((item)=> item.toJson()).toList()
    };
  }

}

