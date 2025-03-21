import 'package:audio_player_and_equalizer/core/utils/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/song_model.dart';
import '../../../data/sources/remote/song_remote_datasource.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongRemoteDataSource remoteDataSource;
  final AudioService audioService;

  SongBloc({required this.remoteDataSource, required this.audioService})
      : super(SongInitial()) {
    on<FetchSongs>(_onFetchSongs);
    on<LoadPlaylist>(_onLoadPlaylist);
  }

  Future<void> _onFetchSongs(FetchSongs event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final songs = await remoteDataSource.fetchSongs();
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> _onLoadPlaylist(
      LoadPlaylist event, Emitter<SongState> emit) async {
    await audioService.loadPlaylist(event.songs);
  }
}
