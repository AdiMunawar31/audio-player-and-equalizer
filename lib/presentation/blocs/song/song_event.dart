part of 'song_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

class FetchSongs extends SongEvent {}

class LoadPlaylist extends SongEvent {
  final List<SongModel> songs;

  const LoadPlaylist(this.songs);

  @override
  List<Object> get props => [songs];
}
