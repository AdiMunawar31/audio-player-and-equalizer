part of 'equalizer_bloc.dart';

abstract class EqualizerState extends Equatable {
  const EqualizerState();
  @override
  List<Object?> get props => [];
}

class EqualizerInitial extends EqualizerState {}

class EqualizerLoaded extends EqualizerState {
  final List<int> bandLevels;
  final List<String> presets;
  final String selectedPreset;

  const EqualizerLoaded({
    required this.bandLevels,
    required this.presets,
    required this.selectedPreset,
  });

  EqualizerLoaded copyWith({
    List<int>? bandLevels,
    List<String>? presets,
    String? selectedPreset,
  }) {
    return EqualizerLoaded(
      bandLevels: bandLevels ?? this.bandLevels,
      presets: presets ?? this.presets,
      selectedPreset: selectedPreset ?? this.selectedPreset,
    );
  }

  @override
  List<Object?> get props => [bandLevels, presets, selectedPreset];
}

class EqualizerPresetUpdated extends EqualizerState {
  final String selectedPreset;
  const EqualizerPresetUpdated(this.selectedPreset);

  @override
  List<Object?> get props => [selectedPreset];
}

class EqualizerError extends EqualizerState {
  final String message;
  const EqualizerError(this.message);

  @override
  List<Object?> get props => [message];
}
