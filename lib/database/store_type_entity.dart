import 'package:floor/floor.dart';

@Entity(tableName: 'store_type')
class StoreTypeEntity{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String desc;

  StoreTypeEntity({this.id,required this.title,required this.desc});
}