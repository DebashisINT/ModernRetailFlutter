import 'dart:ffi';

import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/state_pin_entity.dart';

@dao
abstract class StatePinDao{
  @Query('select * from state_pin')
  Future<List<StatePinEntity>> getAll();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStatePin(StatePinEntity statePin);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStatePinAll(List<StatePinEntity> statePins);

  @Query('SELECT state_id FROM state_pin WHERE pincode = :pincode')
  Future<int?> getStateIDByPincode(String pincode);
}