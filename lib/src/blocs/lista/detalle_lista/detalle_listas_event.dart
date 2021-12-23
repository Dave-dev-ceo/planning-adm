part of 'detalle_listas_bloc.dart';

@immutable
abstract class DetalleListasEvent {}

class FechtDetalleListaEvent implements DetalleListasEvent {
  final int idLista;
  FechtDetalleListaEvent(this.idLista);
  int get props => idLista;
}

class FechtDetalleListaIdPlannerEvent extends DetalleListasEvent {
  FechtDetalleListaIdPlannerEvent();
}

class CreateDetalleListasEvent extends DetalleListasEvent {
  final Map<String, dynamic> data;
  final ItemModelDetalleListas listas;
  CreateDetalleListasEvent(this.data, this.listas);
  List<Object> get props => [data, listas];
}

class DeleteDetalleListaEvent extends DetalleListasEvent {
  final int idDetalleLista;
  final int idLista;
  DeleteDetalleListaEvent(this.idDetalleLista, this.idLista);
  List<Object> get props => [idDetalleLista, idLista];
}

class UpdateDetalleListasEvent extends DetalleListasEvent {
  final Map<String, dynamic> data;
  final ItemModelDetalleListas listas;
  UpdateDetalleListasEvent(this.data, this.listas);
  List<Object> get props => [data, listas];
}

class CreateListasEvent extends DetalleListasEvent {
  final Map<String, dynamic> data;
  final ItemModelDetalleListas listas;
  CreateListasEvent(this.data, this.listas);
  List<Object> get props => [data, listas];
}

class UpdateListasEvent extends DetalleListasEvent {
  final Map<String, dynamic> data;
  final ItemModelDetalleListas listas;
  UpdateListasEvent(this.data, this.listas);
  List<Object> get props => [data, listas];
}
