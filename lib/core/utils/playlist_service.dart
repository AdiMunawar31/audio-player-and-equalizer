import 'package:just_audio/just_audio.dart';
import '../../data/models/song_model.dart';

class PlaylistService {
  final AudioPlayer _player = AudioPlayer();
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );

  AudioPlayer get player => _player;
  List<SongModel> _songs = [];

  List<SongModel> get songs => _songs;

  Future<void> addSong(SongModel song) async {
    if (!isSongInPlaylist(song)) {
      final audioSource = AudioSource.uri(Uri.parse(song.audioUrl));
      _songs.add(song);
      await _playlist.add(audioSource);
    }
  }

  Future<void> removeSongById(String songId) async {
    final index = _songs.indexWhere((song) => song.id == songId);
    if (index != -1) {
      _songs.removeAt(index);
      await _playlist.removeAt(index);
    }
  }

  bool isSongInPlaylist(SongModel song) {
    return _songs.any((s) => s.id == song.id);
  }

  Future<void> loadPlaylist() async {
    await _player.setAudioSource(_playlist);
  }
}
