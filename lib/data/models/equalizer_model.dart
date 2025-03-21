import 'package:equatable/equatable.dart';

class EqualizerModel extends Equatable {
  final int bassBoost;
  final int virtualizer;
  final List<int> bandLevels;

  const EqualizerModel({
    required this.bassBoost,
    required this.virtualizer,
    required this.bandLevels,
  });

  EqualizerModel copyWith({
    int? bassBoost,
    int? virtualizer,
    List<int>? bandLevels,
  }) {
    return EqualizerModel(
      bassBoost: bassBoost ?? this.bassBoost,
      virtualizer: virtualizer ?? this.virtualizer,
      bandLevels: bandLevels ?? this.bandLevels,
    );
  }

  @override
  List<Object> get props => [bassBoost, virtualizer, bandLevels];
}
