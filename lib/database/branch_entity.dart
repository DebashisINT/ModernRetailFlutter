import 'package:floor/floor.dart';

@Entity(tableName: "mr_branch")
class BranchEntity{
  @PrimaryKey(autoGenerate: false)
  final int branch_id;
  final String branch_name;

  BranchEntity({this.branch_id=0, this.branch_name=""});

  factory BranchEntity.fromJson(Map<String,dynamic> json){
    return BranchEntity(
        branch_id: json['branch_id'],branch_name: json['branch_name']);
  }

  Map<String,dynamic> toJson(){
    return{
      'branch_id':branch_id,
      'branch_name':branch_name,
    };
  }
}

@dao
abstract class BranchDao{
  @Query('select * from mr_branch')
  Future<List<BranchEntity>> getAll();

  @Query('delete from mr_branch')
  Future<void> deleteAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<BranchEntity> list);

  @Query('SELECT * FROM mr_branch WHERE branch_id = :branch_id')
  Future<BranchEntity?> getBranchDtls(String branch_id);
}