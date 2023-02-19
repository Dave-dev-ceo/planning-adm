part of 'proveedor_bloc.dart';

@immutable
abstract class ProveedorEvent {}

class CreateProveedorEvent extends ProveedorEvent {
  final Map<String, dynamic> data;
  final ItemModelProveedores? listas;
  CreateProveedorEvent(this.data, this.listas);
  List<Object?> get props => [data, listas];
}

class FechtProveedorEvent implements ProveedorEvent {}

class FechtSevicioByProveedorEvent extends ProveedorEvent {}

class DeleteServicioProvEvent extends ProveedorEvent {
  final int? idServicio;
  final int? idProveedor;
  DeleteServicioProvEvent(this.idServicio, this.idProveedor);
  List<Object?> get props => [idServicio, idProveedor];
}

class InsertServicioProvEvent extends ProveedorEvent {
  final int? idServicio;
  final int? idProveedor;

  InsertServicioProvEvent(this.idServicio, this.idProveedor);
  List<Object?> get props => [idServicio, idProveedor];
}

class UpdateProveedor extends ProveedorEvent {
  final ItemProveedor? proveedor;

  UpdateProveedor(
    this.proveedor,
  );
}
