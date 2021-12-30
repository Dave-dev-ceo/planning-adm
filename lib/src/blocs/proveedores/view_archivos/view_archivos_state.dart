part of 'view_archivos_bloc.dart';

@immutable
abstract class ViewArchivosState {}

class ViewArchivosInitial extends ViewArchivosState {}

class MostrarArchivoByIdState extends ViewArchivosState {
  final ItemModelArchivoProvServ detlistas;
  MostrarArchivoByIdState(this.detlistas);
  ItemModelArchivoProvServ get props => detlistas;
}

class MostrarArchivoEspecialByIdState extends ViewArchivosState {
  final ItemModelArchivoEspecial detlistas;
  MostrarArchivoEspecialByIdState(this.detlistas);
  ItemModelArchivoEspecial get props => detlistas;
}

class ErrorArchivoByIdState extends ViewArchivosState {
  final String message;
  ErrorArchivoByIdState(this.message);
  List<Object> get props => [message];
}
