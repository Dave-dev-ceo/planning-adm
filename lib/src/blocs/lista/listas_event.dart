part of 'listas_bloc.dart';

@immutable
abstract class ListasEvent {}

class FechtListasEvent implements ListasEvent {}

class FetchListasIdPlannerEvent extends ListasEvent {
  FetchListasIdPlannerEvent();
}

class DeleteListaEvent extends ListasEvent {
  final Map<String, dynamic> data;
  DeleteListaEvent(this.data);
  List<Object> get props => [data];
}
