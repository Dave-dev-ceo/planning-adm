part of 'archivo_proveedor_bloc.dart';

@immutable
abstract class ArchivoProveedorEvent {}

class CreateArchivoProvServEvent extends ArchivoProveedorEvent {
  final Map<String, dynamic> data;
  final ItemModelProveedores listas;
  CreateArchivoProvServEvent(this.data, this.listas);
  List<Object> get props => [data, listas];
}

class FechtArchivoProvServEvent extends ArchivoProveedorEvent {
  final int id_proveedor;
  final int id_servicio;
  FechtArchivoProvServEvent(this.id_proveedor, this.id_servicio);
  List<Object> get props => [id_proveedor, id_servicio];
}

class DeleteArchivoEvent extends ArchivoProveedorEvent {
  final int idArchivo;
  final int idProveedor;
  final int idServicio;
  DeleteArchivoEvent(this.idArchivo, this.idProveedor, this.idServicio);
  List<Object> get props => [idArchivo];
}
