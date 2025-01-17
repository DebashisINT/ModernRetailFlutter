// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  StoreTypeDao? _storeTypeDaoInstance;

  StatePinDao? _statePinDaoInstance;

  ProductDao? _productDaoInstance;

  ProductRateDao? _productRateDaoInstance;

  StockSaveDao? _stockSaveDaoInstance;

  StockSaveDtlsDao? _stockSaveDtlsDaoInstance;

  StoreDao? _storeDaoInstance;

  StockProductDao? _stockProductDaoInstance;

  OrderProductDao? _orderProductDaoInstance;

  OrderSaveDao? _orderSaveDaoInstance;

  OrderSaveDtlsDao? _orderSaveDtlsDaoInstance;

  BranchDao? _branchDaoInstance;

  ProductUOMDao? _productUOMDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_store_type` (`type_id` INTEGER NOT NULL, `type_name` TEXT NOT NULL, PRIMARY KEY (`type_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_store` (`store_id` TEXT NOT NULL, `branch_id` INTEGER NOT NULL, `store_name` TEXT NOT NULL, `store_address` TEXT NOT NULL, `store_pincode` TEXT NOT NULL, `store_lat` TEXT, `store_long` TEXT, `store_contact_name` TEXT NOT NULL, `store_contact_number` TEXT NOT NULL, `store_alternet_contact_number` TEXT, `store_whatsapp_number` TEXT, `store_email` TEXT, `store_type` INTEGER NOT NULL, `store_size_area` TEXT, `store_state_id` INTEGER NOT NULL, `remarks` TEXT, `create_date_time` TEXT, `store_pic_url` TEXT NOT NULL, `isUploaded` INTEGER NOT NULL, PRIMARY KEY (`store_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_state_pin` (`pin_id` INTEGER NOT NULL, `pincode` TEXT NOT NULL, `city_id` INTEGER NOT NULL, `city_name` TEXT NOT NULL, `state_id` INTEGER NOT NULL, `state_name` TEXT NOT NULL, PRIMARY KEY (`pin_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_product` (`product_id` INTEGER NOT NULL, `product_name` TEXT NOT NULL, `product_description` TEXT NOT NULL, `brand_id` INTEGER NOT NULL, `brand_name` TEXT NOT NULL, `category_id` INTEGER NOT NULL, `category_name` TEXT NOT NULL, `watt_id` INTEGER NOT NULL, `watt_name` TEXT NOT NULL, `product_mrp` REAL NOT NULL, `UOM` TEXT NOT NULL, `product_pic_url` TEXT NOT NULL, PRIMARY KEY (`product_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_product_rate` (`product_id` INTEGER NOT NULL, `state_id` INTEGER NOT NULL, `rate` REAL NOT NULL, PRIMARY KEY (`product_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_branch` (`branch_id` INTEGER NOT NULL, `branch_name` TEXT NOT NULL, PRIMARY KEY (`branch_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_product_uom` (`sl_no` INTEGER PRIMARY KEY AUTOINCREMENT, `product_id` INTEGER NOT NULL, `uom_id` INTEGER NOT NULL, `uom_name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_stock_save` (`stock_id` TEXT NOT NULL, `save_date_time` TEXT NOT NULL, `store_id` TEXT NOT NULL, `remarks` TEXT NOT NULL, PRIMARY KEY (`stock_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_stock_dtls_save` (`sl_no` INTEGER PRIMARY KEY AUTOINCREMENT, `stock_id` TEXT NOT NULL, `product_dtls_id` INTEGER NOT NULL, `product_id` INTEGER NOT NULL, `qty` REAL NOT NULL, `uom_id` INTEGER NOT NULL, `uom` TEXT NOT NULL, `mfg_date` TEXT NOT NULL, `expire_date` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_stock_product` (`sl_no` INTEGER NOT NULL, `product_id` INTEGER NOT NULL, `product_name` TEXT NOT NULL, `product_description` TEXT NOT NULL, `brand_id` INTEGER NOT NULL, `brand_name` TEXT NOT NULL, `category_id` INTEGER NOT NULL, `category_name` TEXT NOT NULL, `watt_id` INTEGER NOT NULL, `watt_name` TEXT NOT NULL, `product_mrp` REAL NOT NULL, `UOM_id` INTEGER NOT NULL, `UOM` TEXT NOT NULL, `product_pic_url` TEXT NOT NULL, `qty` TEXT NOT NULL, `mfgDate` TEXT NOT NULL, `expDate` TEXT NOT NULL, `isAdded` INTEGER NOT NULL, PRIMARY KEY (`sl_no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_order_product` (`sl_no` INTEGER NOT NULL, `product_id` INTEGER NOT NULL, `product_name` TEXT NOT NULL, `product_description` TEXT NOT NULL, `brand_id` INTEGER NOT NULL, `brand_name` TEXT NOT NULL, `category_id` INTEGER NOT NULL, `category_name` TEXT NOT NULL, `watt_id` INTEGER NOT NULL, `watt_name` TEXT NOT NULL, `product_mrp` REAL NOT NULL, `UOM` TEXT NOT NULL, `product_pic_url` TEXT NOT NULL, `state_id` INTEGER NOT NULL, `qty` INTEGER NOT NULL, `rate` REAL NOT NULL, `isAdded` INTEGER NOT NULL, PRIMARY KEY (`sl_no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_order_save` (`order_id` TEXT NOT NULL, `store_id` TEXT NOT NULL, `order_date_time` TEXT NOT NULL, `order_amount` TEXT NOT NULL, `order_status` TEXT NOT NULL, `remarks` TEXT NOT NULL, PRIMARY KEY (`order_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_order_save_dtls` (`sl_no` INTEGER PRIMARY KEY AUTOINCREMENT, `order_id` TEXT NOT NULL, `product_id` TEXT NOT NULL, `qty` TEXT NOT NULL, `rate` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  StoreTypeDao get storeTypeDao {
    return _storeTypeDaoInstance ??= _$StoreTypeDao(database, changeListener);
  }

  @override
  StatePinDao get statePinDao {
    return _statePinDaoInstance ??= _$StatePinDao(database, changeListener);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }

  @override
  ProductRateDao get productRateDao {
    return _productRateDaoInstance ??=
        _$ProductRateDao(database, changeListener);
  }

  @override
  StockSaveDao get stockSaveDao {
    return _stockSaveDaoInstance ??= _$StockSaveDao(database, changeListener);
  }

  @override
  StockSaveDtlsDao get stockSaveDtlsDao {
    return _stockSaveDtlsDaoInstance ??=
        _$StockSaveDtlsDao(database, changeListener);
  }

  @override
  StoreDao get storeDao {
    return _storeDaoInstance ??= _$StoreDao(database, changeListener);
  }

  @override
  StockProductDao get stockProductDao {
    return _stockProductDaoInstance ??=
        _$StockProductDao(database, changeListener);
  }

  @override
  OrderProductDao get orderProductDao {
    return _orderProductDaoInstance ??=
        _$OrderProductDao(database, changeListener);
  }

  @override
  OrderSaveDao get orderSaveDao {
    return _orderSaveDaoInstance ??= _$OrderSaveDao(database, changeListener);
  }

  @override
  OrderSaveDtlsDao get orderSaveDtlsDao {
    return _orderSaveDtlsDaoInstance ??=
        _$OrderSaveDtlsDao(database, changeListener);
  }

  @override
  BranchDao get branchDao {
    return _branchDaoInstance ??= _$BranchDao(database, changeListener);
  }

  @override
  ProductUOMDao get productUOMDao {
    return _productUOMDaoInstance ??= _$ProductUOMDao(database, changeListener);
  }
}

class _$StoreTypeDao extends StoreTypeDao {
  _$StoreTypeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _storeTypeEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_store_type',
            (StoreTypeEntity item) => <String, Object?>{
                  'type_id': item.type_id,
                  'type_name': item.type_name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StoreTypeEntity> _storeTypeEntityInsertionAdapter;

  @override
  Future<List<StoreTypeEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_store_type',
        mapper: (Map<String, Object?> row) => StoreTypeEntity(
            type_id: row['type_id'] as int,
            type_name: row['type_name'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_store_type');
  }

  @override
  Future<String?> getStoreTypeById(String type_id) async {
    return _queryAdapter.query(
        'SELECT type_name FROM mr_store_type WHERE type_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        arguments: [type_id]);
  }

  @override
  Future<StoreTypeEntity?> getStoreTypeDtls(String type_id) async {
    return _queryAdapter.query('SELECT * FROM mr_store_type WHERE type_id = ?1',
        mapper: (Map<String, Object?> row) => StoreTypeEntity(
            type_id: row['type_id'] as int,
            type_name: row['type_name'] as String),
        arguments: [type_id]);
  }

  @override
  Future<void> insertAll(List<StoreTypeEntity> list) async {
    await _storeTypeEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$StatePinDao extends StatePinDao {
  _$StatePinDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _statePinEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_state_pin',
            (StatePinEntity item) => <String, Object?>{
                  'pin_id': item.pin_id,
                  'pincode': item.pincode,
                  'city_id': item.city_id,
                  'city_name': item.city_name,
                  'state_id': item.state_id,
                  'state_name': item.state_name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StatePinEntity> _statePinEntityInsertionAdapter;

  @override
  Future<List<StatePinEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_state_pin',
        mapper: (Map<String, Object?> row) => StatePinEntity(
            pin_id: row['pin_id'] as int,
            pincode: row['pincode'] as String,
            city_id: row['city_id'] as int,
            city_name: row['city_name'] as String,
            state_id: row['state_id'] as int,
            state_name: row['state_name'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_state_pin');
  }

  @override
  Future<int?> getStateIDByPincode(String pincode) async {
    return _queryAdapter.query(
        'SELECT state_id FROM mr_state_pin WHERE pincode = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [pincode]);
  }

  @override
  Future<void> insertAll(List<StatePinEntity> list) async {
    await _statePinEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_product',
            (ProductEntity item) => <String, Object?>{
                  'product_id': item.product_id,
                  'product_name': item.product_name,
                  'product_description': item.product_description,
                  'brand_id': item.brand_id,
                  'brand_name': item.brand_name,
                  'category_id': item.category_id,
                  'category_name': item.category_name,
                  'watt_id': item.watt_id,
                  'watt_name': item.watt_name,
                  'product_mrp': item.product_mrp,
                  'UOM': item.UOM,
                  'product_pic_url': item.product_pic_url
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductEntity> _productEntityInsertionAdapter;

  @override
  Future<List<ProductEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_product',
        mapper: (Map<String, Object?> row) => ProductEntity(
            product_id: row['product_id'] as int,
            product_name: row['product_name'] as String,
            product_description: row['product_description'] as String,
            brand_id: row['brand_id'] as int,
            brand_name: row['brand_name'] as String,
            category_id: row['category_id'] as int,
            category_name: row['category_name'] as String,
            watt_id: row['watt_id'] as int,
            watt_name: row['watt_name'] as String,
            product_mrp: row['product_mrp'] as double,
            UOM: row['UOM'] as String,
            product_pic_url: row['product_pic_url'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_product');
  }

  @override
  Future<List<ProductEntity>> fetchPaginatedItems(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_product ORDER BY product_id ASC LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => ProductEntity(
            product_id: row['product_id'] as int,
            product_name: row['product_name'] as String,
            product_description: row['product_description'] as String,
            brand_id: row['brand_id'] as int,
            brand_name: row['brand_name'] as String,
            category_id: row['category_id'] as int,
            category_name: row['category_name'] as String,
            watt_id: row['watt_id'] as int,
            watt_name: row['watt_name'] as String,
            product_mrp: row['product_mrp'] as double,
            UOM: row['UOM'] as String,
            product_pic_url: row['product_pic_url'] as String),
        arguments: [limit, offset]);
  }

  @override
  Future<List<ProductEntity>> fetchPaginatedItemsSearch(
    String query,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_product WHERE product_name LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => ProductEntity(product_id: row['product_id'] as int, product_name: row['product_name'] as String, product_description: row['product_description'] as String, brand_id: row['brand_id'] as int, brand_name: row['brand_name'] as String, category_id: row['category_id'] as int, category_name: row['category_name'] as String, watt_id: row['watt_id'] as int, watt_name: row['watt_name'] as String, product_mrp: row['product_mrp'] as double, UOM: row['UOM'] as String, product_pic_url: row['product_pic_url'] as String),
        arguments: [query, limit, offset]);
  }

  @override
  Future<void> insertAll(List<ProductEntity> list) async {
    await _productEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$ProductRateDao extends ProductRateDao {
  _$ProductRateDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productRateEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_product_rate',
            (ProductRateEntity item) => <String, Object?>{
                  'product_id': item.product_id,
                  'state_id': item.state_id,
                  'rate': item.rate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductRateEntity> _productRateEntityInsertionAdapter;

  @override
  Future<List<ProductRateEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_product_rate',
        mapper: (Map<String, Object?> row) => ProductRateEntity(
            product_id: row['product_id'] as int,
            state_id: row['state_id'] as int,
            rate: row['rate'] as double));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_product_rate');
  }

  @override
  Future<void> insertAll(List<ProductRateEntity> list) async {
    await _productRateEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$StockSaveDao extends StockSaveDao {
  _$StockSaveDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _stockSaveEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_stock_save',
            (StockSaveEntity item) => <String, Object?>{
                  'stock_id': item.stock_id,
                  'save_date_time': item.save_date_time,
                  'store_id': item.store_id,
                  'remarks': item.remarks
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StockSaveEntity> _stockSaveEntityInsertionAdapter;

  @override
  Future<List<StockSaveEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_stock_save',
        mapper: (Map<String, Object?> row) => StockSaveEntity(
            stock_id: row['stock_id'] as String,
            save_date_time: row['save_date_time'] as String,
            store_id: row['store_id'] as String,
            remarks: row['remarks'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_stock_save');
  }

  @override
  Future<void> insertStock(StockSaveEntity obj) async {
    await _stockSaveEntityInsertionAdapter.insert(
        obj, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<StockSaveEntity> list) async {
    await _stockSaveEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$StockSaveDtlsDao extends StockSaveDtlsDao {
  _$StockSaveDtlsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _stockSaveDtlsEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_stock_dtls_save',
            (StockSaveDtlsEntity item) => <String, Object?>{
                  'sl_no': item.sl_no,
                  'stock_id': item.stock_id,
                  'product_dtls_id': item.product_dtls_id,
                  'product_id': item.product_id,
                  'qty': item.qty,
                  'uom_id': item.uom_id,
                  'uom': item.uom,
                  'mfg_date': item.mfg_date,
                  'expire_date': item.expire_date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StockSaveDtlsEntity>
      _stockSaveDtlsEntityInsertionAdapter;

  @override
  Future<List<StockSaveDtlsEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_stock_dtls_save',
        mapper: (Map<String, Object?> row) => StockSaveDtlsEntity(
            sl_no: row['sl_no'] as int?,
            stock_id: row['stock_id'] as String,
            product_dtls_id: row['product_dtls_id'] as int,
            product_id: row['product_id'] as int,
            qty: row['qty'] as double,
            uom_id: row['uom_id'] as int,
            uom: row['uom'] as String,
            mfg_date: row['mfg_date'] as String,
            expire_date: row['expire_date'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_stock_dtls_save');
  }

  @override
  Future<void> insertStockDtls(StockSaveDtlsEntity obj) async {
    await _stockSaveDtlsEntityInsertionAdapter.insert(
        obj, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<StockSaveDtlsEntity> list) async {
    await _stockSaveDtlsEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$StoreDao extends StoreDao {
  _$StoreDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _storeEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_store',
            (StoreEntity item) => <String, Object?>{
                  'store_id': item.store_id,
                  'branch_id': item.branch_id,
                  'store_name': item.store_name,
                  'store_address': item.store_address,
                  'store_pincode': item.store_pincode,
                  'store_lat': item.store_lat,
                  'store_long': item.store_long,
                  'store_contact_name': item.store_contact_name,
                  'store_contact_number': item.store_contact_number,
                  'store_alternet_contact_number':
                      item.store_alternet_contact_number,
                  'store_whatsapp_number': item.store_whatsapp_number,
                  'store_email': item.store_email,
                  'store_type': item.store_type,
                  'store_size_area': item.store_size_area,
                  'store_state_id': item.store_state_id,
                  'remarks': item.remarks,
                  'create_date_time': item.create_date_time,
                  'store_pic_url': item.store_pic_url,
                  'isUploaded': item.isUploaded ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StoreEntity> _storeEntityInsertionAdapter;

  @override
  Future<List<StoreEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_store',
        mapper: (Map<String, Object?> row) => StoreEntity(
            store_id: row['store_id'] as String,
            branch_id: row['branch_id'] as int,
            store_name: row['store_name'] as String,
            store_address: row['store_address'] as String,
            store_pincode: row['store_pincode'] as String,
            store_lat: row['store_lat'] as String?,
            store_long: row['store_long'] as String?,
            store_contact_name: row['store_contact_name'] as String,
            store_contact_number: row['store_contact_number'] as String,
            store_alternet_contact_number:
                row['store_alternet_contact_number'] as String?,
            store_whatsapp_number: row['store_whatsapp_number'] as String?,
            store_email: row['store_email'] as String?,
            store_type: row['store_type'] as int,
            store_size_area: row['store_size_area'] as String?,
            store_state_id: row['store_state_id'] as int,
            remarks: row['remarks'] as String?,
            create_date_time: row['create_date_time'] as String?,
            store_pic_url: row['store_pic_url'] as String,
            isUploaded: (row['isUploaded'] as int) != 0));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_store');
  }

  @override
  Future<List<StoreEntity>> fetchPaginatedItems(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList('SELECT * FROM mr_store LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => StoreEntity(
            store_id: row['store_id'] as String,
            branch_id: row['branch_id'] as int,
            store_name: row['store_name'] as String,
            store_address: row['store_address'] as String,
            store_pincode: row['store_pincode'] as String,
            store_lat: row['store_lat'] as String?,
            store_long: row['store_long'] as String?,
            store_contact_name: row['store_contact_name'] as String,
            store_contact_number: row['store_contact_number'] as String,
            store_alternet_contact_number:
                row['store_alternet_contact_number'] as String?,
            store_whatsapp_number: row['store_whatsapp_number'] as String?,
            store_email: row['store_email'] as String?,
            store_type: row['store_type'] as int,
            store_size_area: row['store_size_area'] as String?,
            store_state_id: row['store_state_id'] as int,
            remarks: row['remarks'] as String?,
            create_date_time: row['create_date_time'] as String?,
            store_pic_url: row['store_pic_url'] as String,
            isUploaded: (row['isUploaded'] as int) != 0),
        arguments: [limit, offset]);
  }

  @override
  Future<List<StoreEntity>> fetchPaginatedItemsSearch(
    String query,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_store WHERE store_name LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => StoreEntity(
            store_id: row['store_id'] as String,
            branch_id: row['branch_id'] as int,
            store_name: row['store_name'] as String,
            store_address: row['store_address'] as String,
            store_pincode: row['store_pincode'] as String,
            store_lat: row['store_lat'] as String?,
            store_long: row['store_long'] as String?,
            store_contact_name: row['store_contact_name'] as String,
            store_contact_number: row['store_contact_number'] as String,
            store_alternet_contact_number:
                row['store_alternet_contact_number'] as String?,
            store_whatsapp_number: row['store_whatsapp_number'] as String?,
            store_email: row['store_email'] as String?,
            store_type: row['store_type'] as int,
            store_size_area: row['store_size_area'] as String?,
            store_state_id: row['store_state_id'] as int,
            remarks: row['remarks'] as String?,
            create_date_time: row['create_date_time'] as String?,
            store_pic_url: row['store_pic_url'] as String,
            isUploaded: (row['isUploaded'] as int) != 0),
        arguments: [query, limit, offset]);
  }

  @override
  Future<void> insertStore(StoreEntity obj) async {
    await _storeEntityInsertionAdapter.insert(obj, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<StoreEntity> list) async {
    await _storeEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$StockProductDao extends StockProductDao {
  _$StockProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _stockProductEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_stock_product',
            (StockProductEntity item) => <String, Object?>{
                  'sl_no': item.sl_no,
                  'product_id': item.product_id,
                  'product_name': item.product_name,
                  'product_description': item.product_description,
                  'brand_id': item.brand_id,
                  'brand_name': item.brand_name,
                  'category_id': item.category_id,
                  'category_name': item.category_name,
                  'watt_id': item.watt_id,
                  'watt_name': item.watt_name,
                  'product_mrp': item.product_mrp,
                  'UOM_id': item.UOM_id,
                  'UOM': item.UOM,
                  'product_pic_url': item.product_pic_url,
                  'qty': item.qty,
                  'mfgDate': item.mfgDate,
                  'expDate': item.expDate,
                  'isAdded': item.isAdded ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StockProductEntity>
      _stockProductEntityInsertionAdapter;

  @override
  Future<List<StockProductEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_stock_product',
        mapper: (Map<String, Object?> row) => StockProductEntity(
            sl_no: row['sl_no'] as int,
            product_id: row['product_id'] as int,
            product_name: row['product_name'] as String,
            product_description: row['product_description'] as String,
            brand_id: row['brand_id'] as int,
            brand_name: row['brand_name'] as String,
            category_id: row['category_id'] as int,
            category_name: row['category_name'] as String,
            watt_id: row['watt_id'] as int,
            watt_name: row['watt_name'] as String,
            product_mrp: row['product_mrp'] as double,
            UOM_id: row['UOM_id'] as int,
            UOM: row['UOM'] as String,
            product_pic_url: row['product_pic_url'] as String,
            qty: row['qty'] as String,
            mfgDate: row['mfgDate'] as String,
            expDate: row['expDate'] as String,
            isAdded: (row['isAdded'] as int) != 0));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_stock_product');
  }

  @override
  Future<void> setData() async {
    await _queryAdapter.queryNoReturn(
        'insert into mr_stock_product (sl_no,product_id,product_name,product_description,     brand_id,brand_name,category_id,category_name,watt_id,watt_name,product_mrp,UOM_id,UOM,     product_pic_url,qty,mfgDate,expDate,isAdded) select (SELECT COUNT(*) + 1 + ROWID FROM mr_stock_product) AS sl_no,PR.product_id,PR.product_name, PR.product_description,PR.brand_id,PR.brand_name,PR.category_id,PR.category_name,PR.watt_id, PR.watt_name,PR.product_mrp, (select uom_id from mr_product_uom where product_id = PR.product_id limit 1) as uom_id, (select uom_name from mr_product_uom where product_id = PR.product_id limit 1) as uom, PR.product_pic_url,\'\' as qty,\'\' as mfgDate,\'\' as expDate,0 as isAdded from mr_product as PR');
  }

  @override
  Future<void> setSlNo() async {
    await _queryAdapter
        .queryNoReturn('update mr_stock_product set sl_no = sl_no - 1');
  }

  @override
  Future<List<StockProductEntity>> fetchPaginatedItemsSearch(
    String query,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_stock_product WHERE product_name LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => StockProductEntity(sl_no: row['sl_no'] as int, product_id: row['product_id'] as int, product_name: row['product_name'] as String, product_description: row['product_description'] as String, brand_id: row['brand_id'] as int, brand_name: row['brand_name'] as String, category_id: row['category_id'] as int, category_name: row['category_name'] as String, watt_id: row['watt_id'] as int, watt_name: row['watt_name'] as String, product_mrp: row['product_mrp'] as double, UOM_id: row['UOM_id'] as int, UOM: row['UOM'] as String, product_pic_url: row['product_pic_url'] as String, qty: row['qty'] as String, mfgDate: row['mfgDate'] as String, expDate: row['expDate'] as String, isAdded: (row['isAdded'] as int) != 0),
        arguments: [query, limit, offset]);
  }

  @override
  Future<void> insertAll(List<StockProductEntity> list) async {
    await _stockProductEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$OrderProductDao extends OrderProductDao {
  _$OrderProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _orderProductEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_order_product',
            (OrderProductEntity item) => <String, Object?>{
                  'sl_no': item.sl_no,
                  'product_id': item.product_id,
                  'product_name': item.product_name,
                  'product_description': item.product_description,
                  'brand_id': item.brand_id,
                  'brand_name': item.brand_name,
                  'category_id': item.category_id,
                  'category_name': item.category_name,
                  'watt_id': item.watt_id,
                  'watt_name': item.watt_name,
                  'product_mrp': item.product_mrp,
                  'UOM': item.UOM,
                  'product_pic_url': item.product_pic_url,
                  'state_id': item.state_id,
                  'qty': item.qty,
                  'rate': item.rate,
                  'isAdded': item.isAdded ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OrderProductEntity>
      _orderProductEntityInsertionAdapter;

  @override
  Future<List<OrderProductEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_order_product',
        mapper: (Map<String, Object?> row) => OrderProductEntity(
            sl_no: row['sl_no'] as int,
            product_id: row['product_id'] as int,
            product_name: row['product_name'] as String,
            product_description: row['product_description'] as String,
            brand_id: row['brand_id'] as int,
            brand_name: row['brand_name'] as String,
            category_id: row['category_id'] as int,
            category_name: row['category_name'] as String,
            watt_id: row['watt_id'] as int,
            watt_name: row['watt_name'] as String,
            product_mrp: row['product_mrp'] as double,
            UOM: row['UOM'] as String,
            product_pic_url: row['product_pic_url'] as String,
            state_id: row['state_id'] as int,
            qty: row['qty'] as int,
            rate: row['rate'] as double,
            isAdded: (row['isAdded'] as int) != 0));
  }

  @override
  Future<List<OrderProductEntity>> getAllAdded() async {
    return _queryAdapter.queryList(
        'select * from mr_order_product where isAdded=1',
        mapper: (Map<String, Object?> row) => OrderProductEntity(
            sl_no: row['sl_no'] as int,
            product_id: row['product_id'] as int,
            product_name: row['product_name'] as String,
            product_description: row['product_description'] as String,
            brand_id: row['brand_id'] as int,
            brand_name: row['brand_name'] as String,
            category_id: row['category_id'] as int,
            category_name: row['category_name'] as String,
            watt_id: row['watt_id'] as int,
            watt_name: row['watt_name'] as String,
            product_mrp: row['product_mrp'] as double,
            UOM: row['UOM'] as String,
            product_pic_url: row['product_pic_url'] as String,
            state_id: row['state_id'] as int,
            qty: row['qty'] as int,
            rate: row['rate'] as double,
            isAdded: (row['isAdded'] as int) != 0));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_order_product');
  }

  @override
  Future<void> setData() async {
    await _queryAdapter.queryNoReturn(
        'insert into mr_order_product (sl_no,product_id,product_name,product_description,     brand_id,brand_name,category_id,category_name,watt_id,watt_name,product_mrp,UOM,     product_pic_url,state_id,qty,rate,isAdded)   select (SELECT COUNT(*) + 1 + ROWID FROM mr_order_product) AS sl_no,   P.product_id,P.product_name,P.product_description,P.brand_id,P.brand_name,   P.category_id,P.category_name,P.watt_id,P.watt_name,P.product_mrp,P.uom,P.product_pic_url,   COALESCE(R.state_id,null,0) as state_id,0 as qty,COALESCE(R.rate,null,0.0) as rate,   0 as isAdded   from mr_product as P   left join mr_product_rate as R on P.product_id = R.product_id');
  }

  @override
  Future<void> setSlNo() async {
    await _queryAdapter
        .queryNoReturn('update mr_order_product set sl_no = sl_no - 1');
  }

  @override
  Future<void> updateAdded(
    int qty,
    double rate,
    bool isAdded,
    int product_id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'update mr_order_product set qty =?1 ,rate=?2 ,isAdded=?3 where product_id=?4',
        arguments: [qty, rate, isAdded ? 1 : 0, product_id]);
  }

  @override
  Future<List<OrderProductEntity>> fetchPaginatedItemsSearch(
    String query,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_order_product WHERE product_name LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => OrderProductEntity(sl_no: row['sl_no'] as int, product_id: row['product_id'] as int, product_name: row['product_name'] as String, product_description: row['product_description'] as String, brand_id: row['brand_id'] as int, brand_name: row['brand_name'] as String, category_id: row['category_id'] as int, category_name: row['category_name'] as String, watt_id: row['watt_id'] as int, watt_name: row['watt_name'] as String, product_mrp: row['product_mrp'] as double, UOM: row['UOM'] as String, product_pic_url: row['product_pic_url'] as String, state_id: row['state_id'] as int, qty: row['qty'] as int, rate: row['rate'] as double, isAdded: (row['isAdded'] as int) != 0),
        arguments: [query, limit, offset]);
  }

  @override
  Future<List<OrderProductEntity>> fetchPaginatedItems(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_order_product LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => OrderProductEntity(
            sl_no: row['sl_no'] as int,
            product_id: row['product_id'] as int,
            product_name: row['product_name'] as String,
            product_description: row['product_description'] as String,
            brand_id: row['brand_id'] as int,
            brand_name: row['brand_name'] as String,
            category_id: row['category_id'] as int,
            category_name: row['category_name'] as String,
            watt_id: row['watt_id'] as int,
            watt_name: row['watt_name'] as String,
            product_mrp: row['product_mrp'] as double,
            UOM: row['UOM'] as String,
            product_pic_url: row['product_pic_url'] as String,
            state_id: row['state_id'] as int,
            qty: row['qty'] as int,
            rate: row['rate'] as double,
            isAdded: (row['isAdded'] as int) != 0),
        arguments: [limit, offset]);
  }

  @override
  Future<List<OrderProductEntity>> fetchPaginatedItemsAdded(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_order_product where isAdded=1 LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => OrderProductEntity(
            sl_no: row['sl_no'] as int,
            product_id: row['product_id'] as int,
            product_name: row['product_name'] as String,
            product_description: row['product_description'] as String,
            brand_id: row['brand_id'] as int,
            brand_name: row['brand_name'] as String,
            category_id: row['category_id'] as int,
            category_name: row['category_name'] as String,
            watt_id: row['watt_id'] as int,
            watt_name: row['watt_name'] as String,
            product_mrp: row['product_mrp'] as double,
            UOM: row['UOM'] as String,
            product_pic_url: row['product_pic_url'] as String,
            state_id: row['state_id'] as int,
            qty: row['qty'] as int,
            rate: row['rate'] as double,
            isAdded: (row['isAdded'] as int) != 0),
        arguments: [limit, offset]);
  }

  @override
  Future<int?> getProductAddedCount() async {
    return _queryAdapter.query(
        'select count(*)As count from mr_order_product WHERE isAdded=1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> discardProduct(
    bool isAdded,
    int product_id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'update mr_order_product set isAdded=?1 , qty=0 , rate=0 where product_id=?2',
        arguments: [isAdded ? 1 : 0, product_id]);
  }

  @override
  Future<int?> getTotalQty() async {
    return _queryAdapter.query(
        'Select COALESCE(sum(qty),0) as qty from mr_order_product WHERE isAdded=1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<double?> getTotalAmt() async {
    return _queryAdapter.query(
        'select COALESCE(sum(qty * rate), 0.0) as totalAmt from mr_order_product where isAdded = 1',
        mapper: (Map<String, Object?> row) => row.values.first as double);
  }

  @override
  Future<void> insertAll(List<OrderProductEntity> list) async {
    await _orderProductEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$OrderSaveDao extends OrderSaveDao {
  _$OrderSaveDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _orderSaveEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_order_save',
            (OrderSaveEntity item) => <String, Object?>{
                  'order_id': item.order_id,
                  'store_id': item.store_id,
                  'order_date_time': item.order_date_time,
                  'order_amount': item.order_amount,
                  'order_status': item.order_status,
                  'remarks': item.remarks
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OrderSaveEntity> _orderSaveEntityInsertionAdapter;

  @override
  Future<List<OrderSaveEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_order_save',
        mapper: (Map<String, Object?> row) => OrderSaveEntity(
            order_id: row['order_id'] as String,
            store_id: row['store_id'] as String,
            order_date_time: row['order_date_time'] as String,
            order_amount: row['order_amount'] as String,
            order_status: row['order_status'] as String,
            remarks: row['remarks'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_order_save');
  }

  @override
  Future<List<OrderSaveEntity>> fetchPaginatedItems(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_order_save ORDER BY order_date_time ASC LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => OrderSaveEntity(order_id: row['order_id'] as String, store_id: row['store_id'] as String, order_date_time: row['order_date_time'] as String, order_amount: row['order_amount'] as String, order_status: row['order_status'] as String, remarks: row['remarks'] as String),
        arguments: [limit, offset]);
  }

  @override
  Future<void> insert(OrderSaveEntity obj) async {
    await _orderSaveEntityInsertionAdapter.insert(
        obj, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<OrderSaveEntity> list) async {
    await _orderSaveEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$OrderSaveDtlsDao extends OrderSaveDtlsDao {
  _$OrderSaveDtlsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _orderSaveDtlsEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_order_save_dtls',
            (OrderSaveDtlsEntity item) => <String, Object?>{
                  'sl_no': item.sl_no,
                  'order_id': item.order_id,
                  'product_id': item.product_id,
                  'qty': item.qty,
                  'rate': item.rate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OrderSaveDtlsEntity>
      _orderSaveDtlsEntityInsertionAdapter;

  @override
  Future<List<OrderSaveDtlsEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_order_save_dtls',
        mapper: (Map<String, Object?> row) => OrderSaveDtlsEntity(
            sl_no: row['sl_no'] as int?,
            order_id: row['order_id'] as String,
            product_id: row['product_id'] as String,
            qty: row['qty'] as String,
            rate: row['rate'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_order_save_dtls');
  }

  @override
  Future<List<OrderSaveDtlsEntity>> fetchPaginatedItems(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_order_save_dtls ORDER BY order_date_time ASC LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => OrderSaveDtlsEntity(sl_no: row['sl_no'] as int?, order_id: row['order_id'] as String, product_id: row['product_id'] as String, qty: row['qty'] as String, rate: row['rate'] as String),
        arguments: [limit, offset]);
  }

  @override
  Future<int?> getItemCount(String order_id) async {
    return _queryAdapter.query(
        'select count(*) as itemCount from mr_order_save_dtls where mr_order_save_dtls.order_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [order_id]);
  }

  @override
  Future<void> insert(OrderSaveDtlsEntity obj) async {
    await _orderSaveDtlsEntityInsertionAdapter.insert(
        obj, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAll(List<OrderSaveDtlsEntity> list) async {
    await _orderSaveDtlsEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$BranchDao extends BranchDao {
  _$BranchDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _branchEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_branch',
            (BranchEntity item) => <String, Object?>{
                  'branch_id': item.branch_id,
                  'branch_name': item.branch_name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BranchEntity> _branchEntityInsertionAdapter;

  @override
  Future<List<BranchEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_branch',
        mapper: (Map<String, Object?> row) => BranchEntity(
            branch_id: row['branch_id'] as int,
            branch_name: row['branch_name'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_branch');
  }

  @override
  Future<BranchEntity?> getBranchDtls(String branch_id) async {
    return _queryAdapter.query('SELECT * FROM mr_branch WHERE branch_id = ?1',
        mapper: (Map<String, Object?> row) => BranchEntity(
            branch_id: row['branch_id'] as int,
            branch_name: row['branch_name'] as String),
        arguments: [branch_id]);
  }

  @override
  Future<void> insertAll(List<BranchEntity> list) async {
    await _branchEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}

class _$ProductUOMDao extends ProductUOMDao {
  _$ProductUOMDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productUOMEntityInsertionAdapter = InsertionAdapter(
            database,
            'mr_product_uom',
            (ProductUOMEntity item) => <String, Object?>{
                  'sl_no': item.sl_no,
                  'product_id': item.product_id,
                  'uom_id': item.uom_id,
                  'uom_name': item.uom_name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductUOMEntity> _productUOMEntityInsertionAdapter;

  @override
  Future<List<ProductUOMEntity>> getAll() async {
    return _queryAdapter.queryList('select * from mr_product_uom',
        mapper: (Map<String, Object?> row) => ProductUOMEntity(
            sl_no: row['sl_no'] as int?,
            product_id: row['product_id'] as int,
            uom_id: row['uom_id'] as int,
            uom_name: row['uom_name'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_product_uom');
  }

  @override
  Future<void> insertAll(List<ProductUOMEntity> list) async {
    await _productUOMEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}
