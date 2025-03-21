import '../../models/song_model.dart';
import 'database_helper.dart';

abstract class SongLocalDataSource {
  Future<void> cacheSong(SongModel song);
  Future<List<SongModel>> getCachedSongs();
  Future<void> deleteSong(int id);
}

class SongLocalDataSourceImpl implements SongLocalDataSource {
  final DatabaseHelper databaseHelper;

  SongLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheSong(SongModel song) async {
    await databaseHelper.insertSong(song);
  }

  @override
  Future<List<SongModel>> getCachedSongs() async {
    return await databaseHelper.getSongs();
  }

  @override
  Future<void> deleteSong(int id) async {
    await databaseHelper.deleteSong(id);
  }
}
