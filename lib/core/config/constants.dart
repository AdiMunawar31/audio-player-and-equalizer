class Constants {
  static const String appName = "Audio Player & Equalizer";
}

class ApiConstants {
  static const String baseUrl = "https://api.jamendo.com/v3.0";
  static const String clientId = "13704617";
  static const String tracksEndpoint =
      "$baseUrl/tracks/?client_id=$clientId&format=json&limit=10";
}
