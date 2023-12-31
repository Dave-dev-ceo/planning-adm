part of 'timings_bloc.dart';

@immutable
abstract class TimingsState {}

class TimingsInitial extends TimingsState {}

class LoadingTimingsState extends TimingsState {}

class CreateTimingsState extends TimingsState {}

class UpdateTimingState extends TimingsState {
  final String message;

  UpdateTimingState(this.message);
  String get props => message;
}

class CreateTimingsOkState extends TimingsState {}

class ErrorCreateTimingsState extends TimingsState {
  final String message;

  ErrorCreateTimingsState(this.message);

  List<Object> get props => [message];
}

class MostrarTimingsState extends TimingsState {
  final ItemModelTimings? usuarios;

  MostrarTimingsState(this.usuarios);

  ItemModelTimings? get props => usuarios;
}

class ErrorMostrarTimingsState extends TimingsState {
  final String message;

  ErrorMostrarTimingsState(this.message);

  List<Object> get props => [message];
}

// ERROR EN TOKEN:
class ErrorTokenTimingsState extends TimingsState {
  final String message;

  ErrorTokenTimingsState(this.message);

  List<Object> get props => [message];
}

class TimingDeletedState extends TimingsState {
  final bool wasDeletedTiming;

  TimingDeletedState(this.wasDeletedTiming);
}
