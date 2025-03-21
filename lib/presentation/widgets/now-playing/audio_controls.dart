import 'package:audio_player_and_equalizer/core/config/theme.dart';
import 'package:audio_player_and_equalizer/core/utils/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

class AudioControls extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const AudioControls({super.key, required this.audioPlayer});

  @override
  State<AudioControls> createState() => _AudioControlsState();
}

class _AudioControlsState extends State<AudioControls> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isShuffling = false;
  LoopMode loopMode = LoopMode.off;
  final AudioService _audioService = GetIt.I<AudioService>();

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.audioPlayer;

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });

    _audioPlayer.loopModeStream.listen((mode) {
      setState(() {
        loopMode = mode;
      });
    });

    _audioPlayer.shuffleModeEnabledStream.listen((enabled) {
      setState(() {
        isShuffling = enabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 🔀 Shuffle
        IconButton(
          icon: Icon(
            CupertinoIcons.shuffle,
            color: isShuffling ? primaryGreen : Colors.white,
          ),
          onPressed: () {
            _audioService.toggleShuffle();
          },
        ),

        // ⏮ Previous
        IconButton(
          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
          onPressed: () {
            _audioService.previous();
          },
        ),

        // ▶️ / ⏸ Play/Pause
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            color: primaryGreen,
            size: 70,
          ),
          onPressed: () {
            isPlaying ? _audioService.pause() : _audioService.play();
          },
        ),

        // ⏭ Next
        IconButton(
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
          onPressed: () {
            _audioService.next();
          },
        ),

        // 🔁 Repeat Mode
        IconButton(
          icon: Icon(
            loopMode == LoopMode.one
                ? CupertinoIcons.repeat_1
                : loopMode == LoopMode.all
                    ? CupertinoIcons.repeat
                    : CupertinoIcons.arrow_2_circlepath,
            color: loopMode == LoopMode.off ? Colors.white : primaryGreen,
          ),
          onPressed: () {
            setState(() {
              loopMode = loopMode == LoopMode.off
                  ? LoopMode.one
                  : loopMode == LoopMode.one
                      ? LoopMode.all
                      : LoopMode.off;
            });
            _audioService.setLoopMode(loopMode);
          },
        ),
      ],
    );
  }
}
