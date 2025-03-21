import 'package:flutter/material.dart';
import 'dart:async';

import 'package:equalizer_flutter/equalizer_flutter.dart';

class EqualizerPage extends StatefulWidget {
  final int audioSessionId;

  const EqualizerPage({super.key, required this.audioSessionId});

  @override
  State<EqualizerPage> createState() => _EqualizerPageState();
}

class _EqualizerPageState extends State<EqualizerPage> {
  bool enableCustomEQ = false;

  @override
  void initState() {
    super.initState();
    print("audioSessionId : ${widget.audioSessionId}");
    EqualizerFlutter.init(widget.audioSessionId);
  }

  @override
  void dispose() {
    EqualizerFlutter.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equalizer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Custom Equalizer'),
            value: enableCustomEQ,
            onChanged: (value) {
              EqualizerFlutter.setEnabled(value);
              setState(() {
                enableCustomEQ = value;
              });
            },
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<int>>(
            future: EqualizerFlutter.getBandLevelRange(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return CustomEQ(enableCustomEQ, snapshot.data!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

class CustomEQ extends StatefulWidget {
  final bool enabled;
  final List<int> bandLevelRange;

  const CustomEQ(this.enabled, this.bandLevelRange, {super.key});

  @override
  _CustomEQState createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  late double min, max;
  String? _selectedValue;
  late Future<List<String>> fetchPresets;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchPresets = EqualizerFlutter.getPresetNames();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: EqualizerFlutter.getCenterBandFreqs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: snapshot.data!
                  .asMap()
                  .entries
                  .map((entry) => _buildSliderBand(entry.value, entry.key))
                  .toList(),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: _buildPresets(),
            ),
          ],
        );
      },
    );
  }

  Future<int> getBandLevel(int bandId) async {
    return await EqualizerFlutter.getBandLevel(bandId);
  }

  Widget _buildSliderBand(int freq, int bandId) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: FutureBuilder<int>(
              future: getBandLevel(bandId),
              builder: (context, snapshot) {
                double bandValue = snapshot.data?.toDouble() ?? min;
                double adjustedValue = bandValue;

                return RotatedBox(
                  quarterTurns: 3,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(trackHeight: 1),
                    child: Slider(
                      min: min,
                      max: max,
                      value: adjustedValue,
                      onChanged: (newValue) {
                        double actualValue = newValue;
                        setState(() {
                          EqualizerFlutter.setBandLevel(
                              bandId, actualValue.toInt());
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Text('${freq ~/ 1000} Hz'),
        ],
      ),
    );
  }

  Widget _buildPresets() {
    return FutureBuilder<List<String>>(
      future: fetchPresets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final presets = snapshot.data!;
          if (presets.isEmpty) return const Text('No presets available!');

          return DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Available Presets',
              border: OutlineInputBorder(),
            ),
            value: _selectedValue,
            onChanged: widget.enabled
                ? (String? value) {
                    EqualizerFlutter.setPreset(value!);
                    setState(() {
                      _selectedValue = value;
                    });
                  }
                : null,
            items: presets.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
