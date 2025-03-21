part of 'equalizer_bloc.dart';

abstract class EqualizerEvent extends Equatable {
  const EqualizerEvent();
  @override
  List<Object?> get props => [];
}

class InitEqualizer extends EqualizerEvent {
  final int? audioSessionId;
  const InitEqualizer(this.audioSessionId);

  @override
  List<Object?> get props => [audioSessionId];
}

class UpdateEqualizerSettings extends EqualizerEvent {
  final int bandId;
  final int bandLevel;
  const UpdateEqualizerSettings(this.bandId, this.bandLevel);

  @override
  List<Object?> get props => [bandId, bandLevel];
}

class SetPreset extends EqualizerEvent {
  final String presetName;
  const SetPreset(this.presetName);

  @override
  List<Object?> get props => [presetName];
}

class ReleaseEqualizer extends EqualizerEvent {}
