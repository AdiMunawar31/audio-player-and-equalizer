import 'package:audio_player_and_equalizer/core/utils/audio_service.dart';
import 'package:audio_player_and_equalizer/core/utils/playlist_service.dart';
import 'package:audio_player_and_equalizer/presentation/blocs/song/song_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'data/sources/remote/song_remote_datasource.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register HTTP Client
  locator.registerLazySingleton<http.Client>(() => http.Client());

  locator.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
  locator.registerLazySingleton<AudioService>(() => AudioService());
  locator.registerLazySingleton<PlaylistService>(() => PlaylistService());

  // Register DataSource
  locator.registerLazySingleton<SongRemoteDataSource>(
      () => SongRemoteDataSourceImpl(client: locator()));

  // Register Bloc
  locator.registerFactory(
      () => SongBloc(remoteDataSource: locator(), audioService: locator()));
}
