import 'dart:convert';

class SongModel {
  final String? id;
  final String name;
  final int? duration;
  final String? artistId;
  final String artistName;
  final String? albumName;
  final String? albumId;
  final String coverUrl;
  final String audioUrl;

  SongModel({
    this.id,
    required this.name,
    this.duration,
    this.artistId,
    required this.artistName,
    this.albumName,
    this.albumId,
    required this.coverUrl,
    required this.audioUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      artistId: json['artist_id'],
      artistName: json['artist_name'],
      albumName: json['album_name'],
      albumId: json['album_id'],
      coverUrl: json['album_image'],
      audioUrl: json['audio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'artist_id': artistId,
      'artist_name': artistName,
      'album_name': albumName,
      'album_id': albumId,
      'coverUrl': coverUrl,
      'audioUrl': audioUrl,
    };
  }

  static List<SongModel> fromJsonList(String jsonString) {
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> results = jsonData['results'];

    return results.map((e) => SongModel.fromJson(e)).toList();
  }
}
