part of 'archivo_proveedor_bloc.dart';

@immutable
abstract class ArchivoProveedorEvent {}

class CreateArchivoProvServEvent extends ArchivoProveedorEvent {
  final Map<String, dynamic> data;
  final ItemModelProveedores listas;
  final int idProveedor;
  final int idServicio;
  CreateArchivoProvServEvent(this.data, this.listas, this.idProveedor, this.idServicio);
  List<Object> get props => [data, listas];
}

class FechtArchivoProvServEvent extends ArchivoProveedorEvent {
  final int id_proveedor;
  final int id_servicio;
<<<<<<< HEAD
  FechtArchivoProvServEvent(
    this.id_proveedor,
    this.id_servicio,
  );
=======
  FechtArchivoProvServEvent(this.id_proveedor, this.id_servicio);
>>>>>>> 1e10bb58f2ac74258ee595b4d6d6c989e0d82592
  List<Object> get props => [id_proveedor, id_servicio];
}

class DeleteArchivoEvent extends ArchivoProveedorEvent {
  final int idArchivo;
  final int idProveedor;
  final int idServicio;
  DeleteArchivoEvent(this.idArchivo, this.idProveedor, this.idServicio);
  List<Object> get props => [idArchivo];
}
