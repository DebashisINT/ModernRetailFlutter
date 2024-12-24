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

  ProductDao? _productDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `product` (`product_id` INTEGER NOT NULL, `state_id` INTEGER NOT NULL, `rate` REAL NOT NULL, PRIMARY KEY (`product_id`))');

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
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
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

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productEntityInsertionAdapter = InsertionAdapter(
            database,
            'product',
            (ProductEntity item) => <String, Object?>{
                  'product_id': item.product_id,
                  'state_id': item.state_id,
                  'rate': item.rate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductEntity> _productEntityInsertionAdapter;

  @override
  Future<List<ProductEntity>> getAll() async {
    return _queryAdapter.queryList('select * from product',
        mapper: (Map<String, Object?> row) => ProductEntity(
            product_id: row['product_id'] as int,
            state_id: row['state_id'] as int,
            rate: row['rate'] as double));
  }

  @override
  Future<void> insertProduct(ProductEntity obj) async {
    await _productEntityInsertionAdapter.insert(obj, OnConflictStrategy.abort);
  }
}
