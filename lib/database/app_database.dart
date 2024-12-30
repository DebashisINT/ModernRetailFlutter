import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/product_dao.dart';
import 'package:flutter_demo_one/database/product_entity.dart';
import 'package:flutter_demo_one/database/product_rate_dao.dart';
import 'package:flutter_demo_one/database/product_rate_entity.dart';
import 'package:flutter_demo_one/database/state_pin_dao.dart';
import 'package:flutter_demo_one/database/state_pin_entity.dart';
import 'package:flutter_demo_one/database/store_dao.dart';
import 'package:flutter_demo_one/database/store_entity.dart';
import 'package:flutter_demo_one/database/store_type_dao.dart';

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_demo_one/database/store_type_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'store_type_dao.dart';
part 'app_database.g.dart';

@Database(version: 1, entities: [StoreTypeEntity,StoreEntity,ProductEntity,ProductRateEntity,StatePinEntity])
abstract class AppDatabase extends FloorDatabase{
  StoreTypeDao get storeTypeDao;
  ProductDao get productDao;
  ProductRateDao get productRateDao;
  StoreDao get storeDao;
  StatePinDao get statePinDao;
}
