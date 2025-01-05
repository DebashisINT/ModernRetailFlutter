// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
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

  StockSaveDao? _stockSaveDaoInstance;

  StockSaveDtlsDao? _stockSaveDtlsDaoInstance;

  StoreDao? _storeDaoInstance;

  StockProductDao? _stockProductDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `mr_store` (`store_id` TEXT NOT NULL, `store_name` TEXT NOT NULL, `store_address` TEXT NOT NULL, `store_pincode` TEXT NOT NULL, `store_lat` TEXT, `store_long` TEXT, `store_contact_name` TEXT NOT NULL, `store_contact_number` TEXT NOT NULL, `store_alternet_contact_number` TEXT, `store_whatsapp_number` TEXT, `store_email` TEXT, `store_type` INTEGER NOT NULL, `store_size_area` TEXT, `store_state_id` INTEGER NOT NULL, `remarks` TEXT, `create_date_time` TEXT, `store_pic_url` TEXT NOT NULL, `isUploaded` INTEGER NOT NULL, PRIMARY KEY (`store_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_state_pin` (`pin_id` INTEGER NOT NULL, `pincode` TEXT NOT NULL, `city_id` INTEGER NOT NULL, `city_name` TEXT NOT NULL, `state_id` INTEGER NOT NULL, `state_name` TEXT NOT NULL, PRIMARY KEY (`pin_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_product` (`product_id` INTEGER NOT NULL, `product_name` TEXT NOT NULL, `product_description` TEXT NOT NULL, `brand_id` INTEGER NOT NULL, `brand_name` TEXT NOT NULL, `category_id` INTEGER NOT NULL, `category_name` TEXT NOT NULL, `watt_id` INTEGER NOT NULL, `watt_name` TEXT NOT NULL, `product_mrp` REAL NOT NULL, `UOM` TEXT NOT NULL, `product_pic_url` TEXT NOT NULL, PRIMARY KEY (`product_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_stock_save` (`stock_id` TEXT NOT NULL, `save_date_time` TEXT NOT NULL, `store_id` TEXT NOT NULL, PRIMARY KEY (`stock_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_stock_dtls_save` (`sl_no` INTEGER PRIMARY KEY AUTOINCREMENT, `stock_id` TEXT NOT NULL, `product_id` TEXT NOT NULL, `qty` TEXT NOT NULL, `uom` TEXT NOT NULL, `mfg_date` TEXT NOT NULL, `expire_date` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `mr_stock_product` (`sl_no` INTEGER NOT NULL, `product_id` INTEGER NOT NULL, `product_name` TEXT NOT NULL, `product_description` TEXT NOT NULL, `brand_id` INTEGER NOT NULL, `brand_name` TEXT NOT NULL, `category_id` INTEGER NOT NULL, `category_name` TEXT NOT NULL, `watt_id` INTEGER NOT NULL, `watt_name` TEXT NOT NULL, `product_mrp` REAL NOT NULL, `UOM` TEXT NOT NULL, `product_pic_url` TEXT NOT NULL, `qty` TEXT NOT NULL, `mfgDate` TEXT NOT NULL, `expDate` TEXT NOT NULL, PRIMARY KEY (`sl_no`))');

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
                  'store_id': item.store_id
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
            store_id: row['store_id'] as String));
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
                  'product_id': item.product_id,
                  'qty': item.qty,
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
            product_id: row['product_id'] as String,
            qty: row['qty'] as String,
            uom: row['uom'] as String,
            mfg_date: row['mfg_date'] as String,
            expire_date: row['expire_date'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_stock_dtls_save');
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
                  'UOM': item.UOM,
                  'product_pic_url': item.product_pic_url,
                  'qty': item.qty,
                  'mfgDate': item.mfgDate,
                  'expDate': item.expDate
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
            UOM: row['UOM'] as String,
            product_pic_url: row['product_pic_url'] as String,
            qty: row['qty'] as String,
            mfgDate: row['mfgDate'] as String,
            expDate: row['expDate'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from mr_stock_product');
  }

  @override
  Future<List<StockProductEntity>> fetchPaginatedItemsSearch(
    String query,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM mr_stock_product WHERE product_name LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => StockProductEntity(sl_no: row['sl_no'] as int, product_id: row['product_id'] as int, product_name: row['product_name'] as String, product_description: row['product_description'] as String, brand_id: row['brand_id'] as int, brand_name: row['brand_name'] as String, category_id: row['category_id'] as int, category_name: row['category_name'] as String, watt_id: row['watt_id'] as int, watt_name: row['watt_name'] as String, product_mrp: row['product_mrp'] as double, UOM: row['UOM'] as String, product_pic_url: row['product_pic_url'] as String, qty: row['qty'] as String, mfgDate: row['mfgDate'] as String, expDate: row['expDate'] as String),
        arguments: [query, limit, offset]);
  }

  @override
  Future<void> insertAll(List<StockProductEntity> list) async {
    await _stockProductEntityInsertionAdapter.insertList(
        list, OnConflictStrategy.replace);
  }
}
