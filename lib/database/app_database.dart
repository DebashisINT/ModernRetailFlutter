import 'package:fl/database/product_entity.dart';
import 'package:fl/database/product_rate_entity.dart';
import 'package:fl/database/state_pin_entity.dart';
import 'package:fl/database/stock_product_entity.dart';
import 'package:fl/database/stock_save_dtls_entity.dart';
import 'package:fl/database/stock_save_entity.dart';
import 'package:fl/database/store_entity.dart';
import 'package:fl/database/store_type_entity.dart';
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'order_save_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [StoreTypeEntity,StoreEntity,StatePinEntity,ProductEntity,ProductRateEntity,
  StockSaveEntity,StockSaveDtlsEntity,StockProductEntity,OrderSaveEntity])
abstract class AppDatabase extends FloorDatabase{
  StoreTypeDao get storeTypeDao;
  StatePinDao get statePinDao;
  ProductDao get productDao;
  ProductRateDao get productRateDao;
  StockSaveDao get stockSaveDao;
  StockSaveDtlsDao get stockSaveDtlsDao;
  StoreDao get storeDao;
  StockProductDao get stockProductDao;
  OrderSaveDao get orderSaveDao;
}