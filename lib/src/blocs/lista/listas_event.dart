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
