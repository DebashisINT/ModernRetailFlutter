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

  ProductRateDao? _productRateDaoInstance;

  StoreDao? _storeDaoInstance;

  StatePinDao? _statePinDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `store_type` (`type_id` INTEGER NOT NULL, `type_name` TEXT NOT NULL, PRIMARY KEY (`type_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `store` (`store_id` TEXT NOT NULL, `store_name` TEXT NOT NULL, `store_address` TEXT NOT NULL, `store_pincode` TEXT NOT NULL, `store_lat` TEXT NOT NULL, `store_long` TEXT NOT NULL, `store_contact_name` TEXT NOT NULL, `store_contact_number` TEXT NOT NULL, `store_alternet_contact_number` TEXT NOT NULL, `store_whatsapp_number` TEXT NOT NULL, `store_email` TEXT NOT NULL, `store_type` TEXT NOT NULL, `store_size_area` TEXT NOT NULL, `store_state_id` TEXT NOT NULL, `remarks` TEXT NOT NULL, `create_date_time` TEXT NOT NULL, `store_pic_url` TEXT NOT NULL, `isUploaded` INTEGER NOT NULL, PRIMARY KEY (`store_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `product_rate` (`product_id` INTEGER NOT NULL, `state_id` INTEGER NOT NULL, `rate` REAL NOT NULL, PRIMARY KEY (`product_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `state_pin` (`sl_no` INTEGER PRIMARY KEY AUTOINCREMENT, `pin_id` INTEGER NOT NULL, `pincode` TEXT NOT NULL, `city_id` INTEGER NOT NULL, `city_name` TEXT NOT NULL, `state_id` INTEGER NOT NULL, `state_name` TEXT NOT NULL)');

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
  ProductRateDao get productRateDao {
    return _productRateDaoInstance ??=
        _$ProductRateDao(database, changeListener);
  }

  @override
  StoreDao get storeDao {
    return _storeDaoInstance ??= _$StoreDao(database, changeListener);
  }

  @override
  StatePinDao get statePinDao {
    return _statePinDaoInstance ??= _$StatePinDao(database, changeListener);
  }
}

class _$StoreTypeDao extends StoreTypeDao {
  _$StoreTypeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _storeTypeEntityInsertionAdapter = InsertionAdapter(
            database,
            'store_type',
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
    return _queryAdapter.queryList('select * from store_type',
        mapper: (Map<String, Object?> row) => StoreTypeEntity(
            type_id: row['type_id'] as int,
            type_name: row['type_name'] as String));
  }

  @override
  Future<void> insertStoreType(StoreTypeEntity obj) async {
    await _storeTypeEntityInsertionAdapter.insert(
        obj, OnConflictStrategy.abort);
  }
}

class _$ProductRateDao extends ProductRateDao {
  _$ProductRateDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productRateEntityInsertionAdapter = InsertionAdapter(
            database,
            'product_rate',
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
    return _queryAdapter.queryList('select * from product_rate',
        mapper: (Map<String, Object?> row) => ProductRateEntity(
            product_id: row['product_id'] as int,
            state_id: row['state_id'] as int,
            rate: row['rate'] as double));
  }

  @override
  Future<void> insertProduct(ProductRateEntity obj) async {
    await _productRateEntityInsertionAdapter.insert(
        obj, OnConflictStrategy.abort);
  }
}

class _$StoreDao extends StoreDao {
  _$StoreDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _storeEntityInsertionAdapter = InsertionAdapter(
            database,
            'store',
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
    return _queryAdapter.queryList('select * from store',
        mapper: (Map<String, Object?> row) => StoreEntity(
            store_id: row['store_id'] as String,
            store_name: row['store_name'] as String,
            store_address: row['store_address'] as String,
            store_pincode: row['store_pincode'] as String,
            store_lat: row['store_lat'] as String,
            store_long: row['store_long'] as String,
            store_contact_name: row['store_contact_name'] as String,
            store_contact_number: row['store_contact_number'] as String,
            store_alternet_contact_number:
                row['store_alternet_contact_number'] as String,
            store_whatsapp_number: row['store_whatsapp_number'] as String,
            store_email: row['store_email'] as String,
            store_type: row['store_type'] as String,
            store_size_area: row['store_size_area'] as String,
            store_state_id: row['store_state_id'] as String,
            remarks: row['remarks'] as String,
            create_date_time: row['create_date_time'] as String,
            store_pic_url: row['store_pic_url'] as String,
            isUploaded: (row['isUploaded'] as int) != 0));
  }

  @override
  Future<List<StoreEntity>> getStorePagination(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList('SELECT * FROM store LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => StoreEntity(
            store_id: row['store_id'] as String,
            store_name: row['store_name'] as String,
            store_address: row['store_address'] as String,
            store_pincode: row['store_pincode'] as String,
            store_lat: row['store_lat'] as String,
            store_long: row['store_long'] as String,
            store_contact_name: row['store_contact_name'] as String,
            store_contact_number: row['store_contact_number'] as String,
            store_alternet_contact_number:
                row['store_alternet_contact_number'] as String,
            store_whatsapp_number: row['store_whatsapp_number'] as String,
            store_email: row['store_email'] as String,
            store_type: row['store_type'] as String,
            store_size_area: row['store_size_area'] as String,
            store_state_id: row['store_state_id'] as String,
            remarks: row['remarks'] as String,
            create_date_time: row['create_date_time'] as String,
            store_pic_url: row['store_pic_url'] as String,
            isUploaded: (row['isUploaded'] as int) != 0),
        arguments: [limit, offset]);
  }

  @override
  Future<void> insertStore(StoreEntity obj) async {
    await _storeEntityInsertionAdapter.insert(obj, OnConflictStrategy.abort);
  }
}

class _$StatePinDao extends StatePinDao {
  _$StatePinDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _statePinEntityInsertionAdapter = InsertionAdapter(
            database,
            'state_pin',
            (StatePinEntity item) => <String, Object?>{
                  'sl_no': item.sl_no,
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
    return _queryAdapter.queryList('select * from state_pin',
        mapper: (Map<String, Object?> row) => StatePinEntity(
            sl_no: row['sl_no'] as int?,
            pin_id: row['pin_id'] as int,
            pincode: row['pincode'] as String,
            city_id: row['city_id'] as int,
            city_name: row['city_name'] as String,
            state_id: row['state_id'] as int,
            state_name: row['state_name'] as String));
  }

  @override
  Future<int?> getStateIDByPincode(String pincode) async {
    return _queryAdapter.query(
        'SELECT state_id FROM state_pin WHERE pincode = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [pincode]);
  }

  @override
  Future<void> insertStatePin(StatePinEntity statePin) async {
    await _statePinEntityInsertionAdapter.insert(
        statePin, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertStatePinAll(List<StatePinEntity> statePins) async {
    await _statePinEntityInsertionAdapter.insertList(
        statePins, OnConflictStrategy.replace);
  }
}
