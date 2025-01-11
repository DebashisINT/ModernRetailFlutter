
import 'package:floor/floor.dart';
import 'package:modern_retail/database/product_entity.dart';
import 'package:modern_retail/database/product_rate_entity.dart';
import 'package:modern_retail/database/state_pin_entity.dart';
import 'package:modern_retail/database/stock_product_entity.dart';
import 'package:modern_retail/database/stock_save_dtls_entity.dart';
import 'package:modern_retail/database/stock_save_entity.dart';
import 'package:modern_retail/database/store_entity.dart';
import 'package:modern_retail/database/store_type_entity.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'branch_entity.dart';
import 'order_product_entity.dart';
import 'order_save_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [StoreTypeEntity,StoreEntity,StatePinEntity,ProductEntity,ProductRateEntity,BranchEntity,
  StockSaveEntity,StockSaveDtlsEntity,StockProductEntity,OrderProductEntity,OrderSaveEntity])
abstract class AppDatabase extends FloorDatabase{
  StoreTypeDao get storeTypeDao;
  StatePinDao get statePinDao;
  ProductDao get productDao;
  ProductRateDao get productRateDao;
  StockSaveDao get stockSaveDao;
  StockSaveDtlsDao get stockSaveDtlsDao;
  StoreDao get storeDao;
  StockProductDao get stockProductDao;
  OrderProductDao get orderProductDao;
  OrderSaveDao get orderSaveDao;
  BranchDao get branchDao;
}