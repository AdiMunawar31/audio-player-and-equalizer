# audio_player_and_equalizer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

lib/
│── injection.dart
│── main.dart
│
├── core/
│ ├── config/
│ │ ├── routes.dart
│ │ ├── theme.dart
│ │ ├── styles.dart
│ │ ├── constants.dart
│ │
│ ├── errors/
│ │ ├── failure.dart
│ │ ├── exception.dart
│ │
│ ├── utils/
│ │ ├── audio_service.dart
│ │ ├── network_checker.dart
│ │ ├── permission_handler.dart
│
├── data/
│ ├── models/
│ │ ├── song_model.dart
│ │
│ ├── repositories/
│ │ ├── impl/
│ │ │ ├── song_repository_impl.dart
│ │ ├── song_repository.dart
│ │
│ ├── sources/
│ │ ├── remote/
│ │ │ ├── song_remote_datasource.dart
│
├── presentation/
│ ├── blocs/
│ │ ├── song_bloc/
│ │ │ ├── song_bloc.dart
│ │ │ ├── song_event.dart
│ │ │ ├── song_state.dart
│ │
│ ├── pages/
│ │ ├── home_page.dart
│ │ ├── now_playing_page.dart
│
│ ├── widgets/
│ │ ├── audio_progress_bar.dart
│ │ ├── audio_controls.dart
│ │ ├── now_playing_card.dart

permission_handler: ^11.4.0
flutter_bloc: ^9.1.0
device_info_plus: any
intl: any
share_plus: ^10.1.4
vibration: ^3.1.3
just_audio: ^0.9.46
just_audio_background: ^0.0.1-beta.15
rxdart: ^0.28.0
http: ^1.3.0
audio_service: ^0.18.17
get_it: ^8.0.3
go_router: ^14.8.1
dartz: ^0.10.1
equatable: ^2.0.7
audio_video_progress_bar: ^2.0.3
shared_preferences: ^2.5.2
bloc: ^9.0.0
sqflite: ^2.4.1
lottie: ^3.2.0
dio: ^5.4.0
cached_network_image: ^3.4.1
equalizer_flutter: ^0.0.1
