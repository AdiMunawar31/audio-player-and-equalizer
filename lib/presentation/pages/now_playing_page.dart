import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:audio_player_and_equalizer/core/config/theme.dart';
import 'package:audio_player_and_equalizer/core/utils/playlist_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/song_model.dart';
import '../../core/utils/audio_service.dart';
import '../widgets/now-playing/audio_controls.dart';
import '../widgets/now-playing/audio_progress_bar.dart';

class NowPlayingPage extends StatefulWidget {
  final List<SongModel> songs;
  final int startIndex;

  const NowPlayingPage({
    super.key,
    required this.songs,
    required this.startIndex,
  });

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  final AudioService _audioService = GetIt.I<AudioService>();
  final PlaylistService _playlistService = GetIt.I<PlaylistService>();
  late AudioPlayer _audioPlayer;
  late List<SongModel> _songs;
  StreamSubscription<int?>? _currentIndexSubscription;

  final Floating floating = Floating();

  @override
  void initState() {
    super.initState();
    _audioPlayer = _audioService.player;
    _songs = _audioService.songs;

    _currentIndexSubscription = _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {});
      }
    });

    if (_songs.isNotEmpty) {
      _audioService.setPlaylist(_songs, widget.startIndex);
    }
  }

  Future<void> enablePiP(BuildContext context) async {
    if (!Platform.isAndroid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Picture-in-Picture tidak didukung di perangkat ini')),
      );
      return;
    }

    bool isPiPSupported = false;

    try {
      isPiPSupported = await floating.isPipAvailable;
      if (!isPiPSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Picture-in-Picture tidak didukung di perangkat ini')),
        );
        return;
      }

      final screenSize =
          MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
      final height = screenSize.width ~/ (16 / 9);

      // 🚀 4️⃣ Aktifkan PiP Mode
      final status = await floating.enable(
        ImmediatePiP(
          aspectRatio: Rational(16, 9),
          sourceRectHint: Rectangle<int>(
            0,
            (screenSize.height ~/ 2) - (height ~/ 2),
            screenSize.width.toInt(),
            height,
          ),
        ),
      );

      debugPrint('PiP enabled? $status');
    } on PlatformException catch (e) {
      debugPrint('Gagal mengaktifkan PiP: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengaktifkan PiP: ${e.message}')),
      );
    } on MissingPluginException {
      debugPrint('Plugin PiP tidak ditemukan');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Picture-in-Picture tidak didukung di perangkat ini')),
      );
    }
  }

  @override
  void dispose() {
    _currentIndexSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget nowPlayingContent = Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StreamBuilder<int?>(
          stream: _audioPlayer.currentIndexStream,
          builder: (context, snapshot) {
            final int? currentIndex = snapshot.data;

            if (currentIndex == null || _songs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final SongModel currentSong = _songs[currentIndex];

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 30),
                        onPressed: () => context.pop(),
                      ),
                      const Text(
                        "Now Playing",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _playlistService.isSongInPlaylist(
                                      _songs[_audioPlayer.currentIndex ?? 0])
                                  ? Icons.remove_circle
                                  : Icons.playlist_add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              final currentIndex = _audioPlayer.currentIndex;
                              if (currentIndex != null &&
                                  currentIndex < _songs.length) {
                                final currentSong = _songs[currentIndex];

                                if (_playlistService
                                    .isSongInPlaylist(currentSong)) {
                                  _playlistService
                                      .removeSongById(currentSong.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${currentSong.name} removed from playlist')),
                                  );
                                } else {
                                  print(
                                      "current song ===========> : ${currentSong}");
                                  _playlistService.addSong(currentSong);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${currentSong.name} added to playlist')),
                                  );
                                }

                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// 🔸 Album Cover
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: currentSong.coverUrl,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),

                /// 🔸 Song Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(currentSong.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(currentSong.artistName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.picture_in_picture_alt,
                          color: Colors.white),
                      onPressed: () => enablePiP(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay_10, color: Colors.white),
                      onPressed: () {
                        final newPosition =
                            _audioPlayer.position - const Duration(seconds: 10);
                        _audioPlayer.seek(newPosition > Duration.zero
                            ? newPosition
                            : Duration.zero);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10, color: Colors.white),
                      onPressed: () {
                        final newPosition =
                            _audioPlayer.position + const Duration(seconds: 10);
                        final duration = _audioPlayer.duration ?? newPosition;
                        _audioPlayer.seek(
                            newPosition < duration ? newPosition : duration);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.equalizer, color: Colors.white),
                      onPressed: () {
                        final sessionId = _audioPlayer.androidAudioSessionId;
                        if (sessionId != null) {
                          context.push('/equalizer',
                              extra: {'sessionId': sessionId});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Equalizer tidak didukung di perangkat ini.')),
                          );
                        }
                      },
                    ),
                  ],
                ),

                AudioProgressBar(audioPlayer: _audioPlayer),
                AudioControls(audioPlayer: _audioPlayer),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("Lyrics",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.speaker, color: primaryGreen, size: 20),
                          SizedBox(width: 5),
                          Text("D2Y Onyx Studio 7",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    return Platform.isAndroid
        ? PiPSwitcher(
            childWhenDisabled: nowPlayingContent,
            childWhenEnabled: SafeArea(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    _songs[_audioPlayer.currentIndex ?? 0].coverUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )
        : nowPlayingContent;
  }
}
