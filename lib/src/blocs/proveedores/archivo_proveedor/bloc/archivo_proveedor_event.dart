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
  final int idProveedor;
  final int idServicio;
  final bool isServicio;
  FechtArchivoProvServEvent(this.idProveedor, this.idServicio, this.isServicio);
  List<Object> get props => [idProveedor, idServicio];
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
  final int idProveedor;
  final int idEvento;
  FechtArchivoProvEvent(this.idProveedor, this.idEvento);
  List<Object> get props => [idProveedor, idEvento];
}
