import 'package:audio_player_and_equalizer/core/errors/failure.dart';
import 'package:audio_player_and_equalizer/data/models/song_model.dart';
import 'package:dartz/dartz.dart';

abstract class SongRepository {
  Future<Either<Failure, List<SongModel>>> getSongs();
  Future<Either<Failure, void>> saveSong(SongModel song);
  Future<Either<Failure, void>> deleteSong(int id);
}
