import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';

part 'equalizer_event.dart';
part 'equalizer_state.dart';

class EqualizerBloc extends Bloc<EqualizerEvent, EqualizerState> {
  EqualizerBloc() : super(EqualizerInitial()) {
    on<InitEqualizer>(_onInitEqualizer);
    on<UpdateEqualizerSettings>(_onUpdateEqualizerSettings);
    on<SetPreset>(_onSetPreset);
    on<ReleaseEqualizer>(_onReleaseEqualizer);
  }

  Future<void> _onInitEqualizer(
      InitEqualizer event, Emitter<EqualizerState> emit) async {
    try {
      final sessionId = event.audioSessionId;
      if (sessionId == null) {
        emit(EqualizerError("Audio session ID not available"));
        return;
      }

      await EqualizerFlutter.init(sessionId);
      await EqualizerFlutter.setEnabled(true);

      final List<String> presets = await EqualizerFlutter.getPresetNames();
      final List<int> bandLevels = [];

      /// ✅ Menggunakan `getCenterBandFreqs()` untuk mengetahui jumlah band yang tersedia.
      final List<int> centerFreqs = await EqualizerFlutter.getCenterBandFreqs();
      final int bandCount =
          centerFreqs.length; // Jumlah band = panjang array frekuensi

      for (int i = 0; i < bandCount; i++) {
        final bandLevel = await EqualizerFlutter.getBandLevel(i);
        bandLevels.add(bandLevel);
      }

      emit(EqualizerLoaded(
        bandLevels: bandLevels,
        presets: presets,
        selectedPreset: presets.isNotEmpty ? presets.first : "Custom",
      ));
    } catch (e) {
      emit(EqualizerError("Error initializing Equalizer: $e"));
    }
  }

  Future<void> _onUpdateEqualizerSettings(
      UpdateEqualizerSettings event, Emitter<EqualizerState> emit) async {
    try {
      final currentState = state;
      if (currentState is EqualizerLoaded) {
        await EqualizerFlutter.setBandLevel(event.bandId, event.bandLevel);

        final updatedBandLevels = List<int>.from(currentState.bandLevels);
        updatedBandLevels[event.bandId] = event.bandLevel;

        emit(currentState.copyWith(bandLevels: updatedBandLevels));
      }
    } catch (e) {
      emit(EqualizerError("Error updating band level: $e"));
    }
  }

  Future<void> _onSetPreset(
      SetPreset event, Emitter<EqualizerState> emit) async {
    try {
      await EqualizerFlutter.setPreset(event.presetName);
      emit(EqualizerPresetUpdated(event.presetName));
    } catch (e) {
      emit(EqualizerError("Error setting preset: $e"));
    }
  }

  Future<void> _onReleaseEqualizer(
      ReleaseEqualizer event, Emitter<EqualizerState> emit) async {
    await EqualizerFlutter.release();
    emit(EqualizerInitial());
  }
}
