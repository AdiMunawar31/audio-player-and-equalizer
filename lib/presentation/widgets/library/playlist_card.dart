import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_player_and_equalizer/data/models/song_model.dart';

class PlaylistCard extends StatelessWidget {
  final SongModel song;
  final List<SongModel> songs;
  final int index;

  const PlaylistCard({
    super.key,
    required this.song,
    required this.songs,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: song.coverUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error, color: Colors.red, size: 50),
        ),
      ),
      title: Text(song.name,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text("${song.artistName} | ${song.albumName}",
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
      onTap: () {
        print("Navigating to Now Playing...");
        print("Selected song: ${song.name}");
        print("Songs list: $songs");

        context.push(
          '/now-playing',
          extra: {
            'songs': songs,
            'startIndex': index,
          },
        );
      },
    );
  }
}
