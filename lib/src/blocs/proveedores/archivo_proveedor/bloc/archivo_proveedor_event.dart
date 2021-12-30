part of 'archivo_proveedor_bloc.dart';

@immutable
abstract class ArchivoProveedorEvent {}

class CreateArchivoProvServEvent extends ArchivoProveedorEvent {
  final Map<String, dynamic> data;
  // final ItemModelProveedores listas;
  CreateArchivoProvServEvent(this.data);
  List<Object> get props => [data];
}

class FechtArchivoProvServEvent extends ArchivoProveedorEvent {
  final int id_proveedor;
  final int id_servicio;
  final bool isServicio;
  FechtArchivoProvServEvent(
      this.id_proveedor, this.id_servicio, this.isServicio);
  List<Object> get props => [id_proveedor, id_servicio];
}

class DeleteArchivoEvent extends ArchivoProveedorEvent {
  final int idArchivo;
  final int idProveedor;
  final int idServicio;
  final bool isServici;
  DeleteArchivoEvent(
      this.idArchivo, this.idProveedor, this.idServicio, this.isServici);
  List<Object> get props => [idArchivo];
}

class FechtArchivoProvEvent extends ArchivoProveedorEvent {
  final int id_proveedor;
  final int id_evento;
  FechtArchivoProvEvent(this.id_proveedor, this.id_evento);
  List<Object> get props => [id_proveedor, id_evento];
}
