import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/book.dart';

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._();
  factory LocalDbService() => _instance;
  LocalDbService._();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      p.join(dbPath, 'phat.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            cover_url TEXT DEFAULT '',
            file_url TEXT DEFAULT '',
            description TEXT DEFAULT '',
            category TEXT DEFAULT '',
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> cacheBooks(List<Book> books) async {
    final database = await db;
    final batch = database.batch();
    for (final book in books) {
      batch.insert('books', book.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Book>> getCachedBooks() async {
    final database = await db;
    final rows = await database.query('books', orderBy: 'created_at DESC');
    return rows.map((json) => Book.fromJson(json)).toList();
  }

  Future<Book?> getCachedBook(String id) async {
    final database = await db;
    final rows = await database.query('books', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Book.fromJson(rows.first);
  }

  Future<void> clear() async {
    final database = await db;
    await database.delete('books');
  }
}
