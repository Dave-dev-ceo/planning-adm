part of 'archivos_especiales_bloc.dart';

@immutable
abstract class ArchivosEspecialesEvent {}

class FechtArchivoEspecialEvent extends ArchivosEspecialesEvent {
  final int idProveedor;
  final int idEvento;
  FechtArchivoEspecialEvent(this.idProveedor, this.idEvento);
  List<Object> get props => [idProveedor, idEvento];
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
