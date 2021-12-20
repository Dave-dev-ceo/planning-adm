part of 'archivosespeciales_bloc.dart';

@immutable
abstract class ArchivosEspecialesEvent {}

class MostrarArchivosEspecialesEvent extends ArchivosEspecialesEvent {
  final int idProveedor;
  final int idEvento;

  MostrarArchivosEspecialesEvent(this.idProveedor, this.idEvento);

  List<Object> get props => [idProveedor];
}

class InsertArchivoEspecialEvent extends ArchivosEspecialesEvent {
  final ArchivoEspecialModel newArchivoEspecial;

  InsertArchivoEspecialEvent(this.newArchivoEspecial);
}
