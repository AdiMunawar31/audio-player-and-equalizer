import 'package:audio_player_and_equalizer/presentation/widgets/library/playlist_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:audio_player_and_equalizer/core/utils/playlist_service.dart';
import 'package:audio_player_and_equalizer/data/models/song_model.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final PlaylistService _playlistService = GetIt.I<PlaylistService>();

  @override
  Widget build(BuildContext context) {
    final List<SongModel> playlistSongs = _playlistService.songs;
    print("Songs in playlist: $playlistSongs");

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Playlist"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: playlistSongs.isEmpty
          ? const Center(
              child: Text(
                "No songs in playlist",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: ListView.builder(
                itemCount: playlistSongs.length,
                itemBuilder: (context, index) {
                  final song = playlistSongs[index];
                  return PlaylistCard(
                    song: song,
                    songs: playlistSongs,
                    index: index,
                  );
                },
              ),
            ),
    );
  }
}
