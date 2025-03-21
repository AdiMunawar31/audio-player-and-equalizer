import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class CommonFailure extends Failure {
  const CommonFailure(super.message);
}

class LoadAudioFailure extends Failure {
  const LoadAudioFailure(super.message);
}

class PlayAudioFailure extends Failure {
  const PlayAudioFailure(super.message);
}

class PauseAudioFailure extends Failure {
  const PauseAudioFailure(super.message);
}

class LoopModeFailure extends Failure {
  const LoopModeFailure(super.message);
}
