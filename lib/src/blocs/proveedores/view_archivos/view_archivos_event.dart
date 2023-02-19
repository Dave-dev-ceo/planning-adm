part of 'view_archivos_bloc.dart';

@immutable
abstract class ViewArchivosEvent {}

class FechtArchivoByIdEvent extends ViewArchivosEvent {
  final int? idArchivo;
  FechtArchivoByIdEvent(this.idArchivo);
  List<Object?> get props => [idArchivo];
}

class FechtArchivoEspecialByIdEvent extends ViewArchivosEvent {
  final int? idArchivo;
  FechtArchivoEspecialByIdEvent(this.idArchivo);
  List<Object?> get props => [idArchivo];
}
