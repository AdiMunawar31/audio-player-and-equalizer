import 'package:audio_player_and_equalizer/data/models/song_model.dart';
import 'package:audio_player_and_equalizer/presentation/pages/equalizer_page.dart';
import 'package:audio_player_and_equalizer/presentation/pages/library_page.dart';
import 'package:audio_player_and_equalizer/presentation/pages/now_playing_page.dart';
import 'package:audio_player_and_equalizer/presentation/pages/playlist_page.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/home_page.dart';
// import '../../presentation/pages/now_playing_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/library',
      builder: (context, state) => const LibraryPage(),
    ),
    GoRoute(
      path: '/playlist',
      builder: (context, state) => const PlaylistPage(),
    ),
    GoRoute(
      path: '/now-playing',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final List<SongModel> songs = extra['songs'] as List<SongModel>;
        final int startIndex = extra['startIndex'] as int;

        return NowPlayingPage(songs: songs, startIndex: startIndex);
      },
    ),
    GoRoute(
      path: '/equalizer',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final sessionId = args?['sessionId'] as int?;

        if (sessionId == null) {
          throw Exception("Audio Session ID tidak ditemukan.");
        }

        return EqualizerPage(audioSessionId: sessionId);
      },
    ),
  ],
);
