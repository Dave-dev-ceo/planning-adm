part of 'mesasasignadas_bloc.dart';

@immutable
abstract class MesasAsignadasState {}

class MesasasignadasInitial extends MesasAsignadasState {}

class LoadingMesasAsignadasState extends MesasAsignadasState {}

class MostrarMesasAsignadasState extends MesasAsignadasState {
  final List<MesasAsignadasModel> listaMesasAsignadas;

  MostrarMesasAsignadasState(this.listaMesasAsignadas);
}

class DeletedAsignadoFromMesaState extends MesasAsignadasState {
  final String message;

  DeletedAsignadoFromMesaState(this.message);
}

class AddedAsignadoFromMesaState extends MesasAsignadasState {
  final String message;

  AddedAsignadoFromMesaState(this.message);
}
