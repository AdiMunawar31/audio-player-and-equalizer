import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/song_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'songs';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'songs.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            title TEXT,
            artist TEXT,
            album TEXT,
            url TEXT,
            cover_url TEXT,
            duration INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertSong(SongModel song) async {
    final db = await database;
    await db.insert(tableName, song.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SongModel>> getSongs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => SongModel.fromJson(maps[i]));
  }

  Future<void> deleteSong(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
