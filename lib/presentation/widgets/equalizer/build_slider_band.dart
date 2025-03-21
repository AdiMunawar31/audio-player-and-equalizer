import 'package:flutter/material.dart';

class BuildSliderBand extends StatelessWidget {
  final int bandId;
  final int bandLevel;
  final ValueChanged<int> onChanged;

  const BuildSliderBand({
    Key? key,
    required this.bandId,
    required this.bandLevel,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Band $bandId"),
        Slider(
          value: bandLevel.toDouble(),
          min: -1500,
          max: 1500,
          divisions: 30,
          label: bandLevel.toString(),
          onChanged: (value) => onChanged(value.toInt()),
        ),
      ],
    );
  }
}
