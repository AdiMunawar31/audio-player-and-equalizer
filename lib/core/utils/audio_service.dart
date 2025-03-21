import 'package:just_audio/just_audio.dart';
import '../../data/models/song_model.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  late List<SongModel> _songList;
  late ConcatenatingAudioSource _playlist;

  AudioPlayer get player => _player;

  List<SongModel> get songs => _songList;

  // Stream untuk mendapatkan lagu yang sedang diputar
  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  Future<void> loadPlaylist(List<SongModel> songs) async {
    _songList = songs;

    _playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: songs
          .map((song) => AudioSource.uri(Uri.parse(song.audioUrl)))
          .toList(),
    );

    await _player.setAudioSource(_playlist,
        initialIndex: 0, initialPosition: Duration.zero);
  }

  Future<void> setPlaylist(List<SongModel> songs, int startIndex) async {
    _songList = songs;

    _playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: songs
          .map((song) => AudioSource.uri(Uri.parse(song.audioUrl)))
          .toList(),
    );

    await _player.setAudioSource(
      _playlist,
      initialIndex: startIndex,
      initialPosition: Duration.zero,
    );

    play();
  }

  void play() => _player.play();
  void pause() => _player.pause();
  void next() => _player.seekToNext();
  void previous() => _player.seekToPrevious();
  void seekToIndex(int index) => _player.seek(Duration.zero, index: index);
  void setLoopMode(LoopMode mode) => _player.setLoopMode(mode);
  void toggleShuffle() async {
    bool shuffleEnabled = await _player.shuffleModeEnabled;
    await _player.setShuffleModeEnabled(!shuffleEnabled);
  }

  void dispose() => _player.dispose();
}
