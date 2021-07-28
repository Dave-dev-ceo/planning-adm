part of 'listas_bloc.dart';

@immutable
abstract class ListasEvent {}

class FechtListasEvent implements ListasEvent {
  // final ItemModelArticulosRecibir articulo;
  // FechtArticulosRecibirEvent(this.articulo);
  // List<Object> get props => [articulo];
}

class FetchListasIdPlannerEvent extends ListasEvent {
  FetchListasIdPlannerEvent();
}

class CreateListasEvent extends ListasEvent {
  final Map<String, dynamic> data;
  final ItemModelListas listas;
  CreateListasEvent(this.data, this.listas);
  List<Object> get props => [data, listas];
}
