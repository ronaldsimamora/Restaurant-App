import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static const String _databaseName = 'restaurant-app.db';
  static const String _tableName = 'restaurant';
  static const int _version = 2;

  Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE $_tableName(
         id TEXT PRIMARY KEY,
         name TEXT,
         description TEXT,
         pictureId TEXT,
         city TEXT,
         rating REAL
       )
    """);
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(Restaurant restaurant) async {
    final db = await _initializeDb();
    final data = restaurant.toJson();

    return await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Restaurant>> getAllItems() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName);

    return results.map((e) => Restaurant.fromJson(e)).toList();
  }

  Future<Restaurant?> getItemById(String id) async {
    final db = await _initializeDb();
    final results = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    return results.isEmpty ? null : Restaurant.fromJson(results.first);
  }

  Future<int> removeItem(String id) async {
    final db = await _initializeDb();

    return await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
