part of 'proveedor_bloc.dart';

@immutable
abstract class ProveedorEvent {}

class CreateProveedorEvent extends ProveedorEvent {
  final Map<String, dynamic> data;
  final ItemModelProveedores listas;
  CreateProveedorEvent(this.data, this.listas);
  List<Object> get props => [data, listas];
}

class FechtProveedorEvent implements ProveedorEvent {}

class FechtSevicioByProveedorEvent extends ProveedorEvent {}

class DeleteServicioProvEvent extends ProveedorEvent {
  final int idServicio;
  DeleteServicioProvEvent(this.idServicio);
  List<Object> get props => [idServicio];
}
