import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'currencies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE preferred_currencies(id INTEGER PRIMARY KEY, code TEXT)',
        );
      },
    );
  }

  Future<void> insertCurrency(String code) async {
    final db = await database;
    await db.insert(
      'preferred_currencies',
      {'code': code},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCurrency(String code) async {
    final db = await database;
    await db.delete(
      'preferred_currencies',
      where: 'code = ?',
      whereArgs: [code],
    );
  }

  Future<List<String>> getPreferredCurrencies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('preferred_currencies');
    return List.generate(maps.length, (i) {
      return maps[i]['code'];
    });
  }
}
