part of 'mesas_bloc.dart';

@immutable
abstract class MesasState {}

class MesasInitial extends MesasState {}

class LoadingMesasState extends MesasState {}

class MostrarMesasState extends MesasState {
  final List<MesaModel> listaMesas;

  MostrarMesasState(this.listaMesas);

  List<Object> get props => [listaMesas];
}

class ErrorMesasState extends MesasState {
  final String message;

  ErrorMesasState(this.message);
  List<Object> get props => [message];
}

class ErrorTokenMesasState extends MesasState {
  final String message;

  ErrorTokenMesasState({this.message});

  List<Object> get props => [message];
}

class CreateMesasState extends MesasState {}

class CreatedMesasState extends MesasState {
  final String response;

  CreatedMesasState(this.response);

  String get props => response;
}

class ErrorCreateMesasState extends MesasState {}
