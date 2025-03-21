import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/constants.dart';
import '../../models/song_model.dart';

abstract class SongRemoteDataSource {
  Future<List<SongModel>> fetchSongs();
}

class SongRemoteDataSourceImpl implements SongRemoteDataSource {
  final http.Client client;

  SongRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SongModel>> fetchSongs() async {
    try {
      final response = await client.get(Uri.parse(ApiConstants.tracksEndpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return (jsonData['results'] as List)
            .map((e) => SongModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
