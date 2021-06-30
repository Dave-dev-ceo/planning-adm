part of 'timings_bloc.dart';

@immutable
abstract class TimingsEvent {}

class FetchTimingsPorPlannerEvent extends TimingsEvent {
  FetchTimingsPorPlannerEvent();
}

class CreateTimingsEvent extends TimingsEvent {
  final Map<String, dynamic> data;
  CreateTimingsEvent(this.data);
  List<Object> get props => [data];
}
