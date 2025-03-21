import 'package:audio_player_and_equalizer/data/repositories/song_repository.dart';
import 'package:dartz/dartz.dart';
import '../../models/song_model.dart';
import '../../sources/local/song_local_datasource.dart';
import '../../sources/remote/song_remote_datasource.dart';
import '../../../core/errors/failure.dart';

class SongRepositoryImpl implements SongRepository {
  final SongRemoteDataSource remoteDataSource;
  final SongLocalDataSource localDataSource;

  SongRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<SongModel>>> getSongs() async {
    try {
      final remoteSongs = await remoteDataSource.fetchSongs();
      return Right(remoteSongs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSong(SongModel song) async {
    try {
      await localDataSource.cacheSong(song);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSong(int id) async {
    try {
      await localDataSource.deleteSong(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
