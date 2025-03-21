import 'package:audio_player_and_equalizer/presentation/blocs/equalizer/equalizer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomEqControls extends StatelessWidget {
  const CustomEqControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () =>
              context.read<EqualizerBloc>().add(ReleaseEqualizer()),
          child: const Text("Reset"),
        ),
      ],
    );
  }
}
