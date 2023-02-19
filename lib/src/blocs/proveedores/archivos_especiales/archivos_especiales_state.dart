part of 'archivos_especiales_bloc.dart';

@immutable
abstract class ArchivosEspecialesState {}

class ArchivosEspecialesInitial extends ArchivosEspecialesState {}

class LoadingArchivoEspecialState extends ArchivosEspecialesState {}

class MostrarArchivoProvEventState extends ArchivosEspecialesState {
  final ItemModelArchivoEspecial detlistas;
  MostrarArchivoProvEventState(this.detlistas);
  ItemModelArchivoEspecial get props => detlistas;
}

class ErrorMostrarArchivEspecialState extends ArchivosEspecialesState {
  final String message;
  ErrorMostrarArchivEspecialState(this.message);
  List<Object> get props => [message];
}
