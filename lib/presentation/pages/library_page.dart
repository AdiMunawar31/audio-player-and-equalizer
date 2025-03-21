import 'package:audio_player_and_equalizer/presentation/blocs/song/song_bloc.dart';
import 'package:audio_player_and_equalizer/presentation/widgets/library/playlist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    super.initState();
    context.read<SongBloc>().add(FetchSongs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Lists Songs",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BlocBuilder<SongBloc, SongState>(
              builder: (context, state) {
                if (state is SongLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SongLoaded) {
                  context.read<SongBloc>().add(LoadPlaylist(state.songs));

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) {
                      final song = state.songs[index];
                      return PlaylistCard(
                        song: song,
                        songs: state.songs,
                        index: index,
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No songs available",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ),

          // Pemutar Musik di Bawah
          // _musicPlayerControls(),
        ],
      ),
    );
  }

  // Widget _musicPlayerControls() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     color: Colors.black54,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         IconButton(
  //           icon: const Icon(Icons.skip_previous, color: Colors.white),
  //           onPressed: () => _audioService.previous(),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.play_arrow, color: Colors.white),
  //           onPressed: () => _audioService.play(),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.pause, color: Colors.white),
  //           onPressed: () => _audioService.pause(),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.skip_next, color: Colors.white),
  //           onPressed: () => _audioService.next(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
