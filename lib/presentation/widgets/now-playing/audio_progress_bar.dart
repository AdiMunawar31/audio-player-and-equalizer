import 'package:audio_player_and_equalizer/core/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';

class AudioProgressBar extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const AudioProgressBar({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: audioPlayer.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: audioPlayer.positionStream,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProgressBar(
                progress: position,
                total: duration,
                onSeek: (duration) {
                  audioPlayer.seek(duration);
                },
                barHeight: 5,
                baseBarColor: Colors.grey.shade800,
                progressBarColor: primaryGreen,
                thumbColor: Colors.white,
                timeLabelTextStyle: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }
}
