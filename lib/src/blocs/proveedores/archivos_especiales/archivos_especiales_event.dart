part of 'archivos_especiales_bloc.dart';

@immutable
abstract class ArchivosEspecialesEvent {}

class FechtArchivoEspecialEvent extends ArchivosEspecialesEvent {
  final int id_proveedor;
  final int id_evento;
  FechtArchivoEspecialEvent(this.id_proveedor, this.id_evento);
  List<Object> get props => [id_proveedor, id_evento];
}

class DeleteArchivoEspecialEvent extends ArchivosEspecialesEvent {
  final int idArchivo;
  final int idProveedor;
  final int idEvento;
  DeleteArchivoEspecialEvent(this.idArchivo, this.idProveedor, this.idEvento);
  List<Object> get props => [idArchivo];
}

class CreateArchivoEspecialEvent extends ArchivosEspecialesEvent {
  final Map<String, dynamic> data;
  CreateArchivoEspecialEvent(this.data);
  List<Object> get props => [data];
}
