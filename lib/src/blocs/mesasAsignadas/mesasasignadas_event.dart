part of 'mesasasignadas_bloc.dart';

@immutable
abstract class MesasAsignadasEvent {}

class GetMesasAsignadasEvent extends MesasAsignadasEvent {}

class DeleteAsignadoFromMesaEvent extends MesasAsignadasEvent {
  final List<MesasAsignadasModel> asignadosToDelete;

  DeleteAsignadoFromMesaEvent(this.asignadosToDelete);
}

class AsignarPersonasMesasEvent extends MesasAsignadasEvent {
  final List<MesasAsignadasModel> listAsignarMesaModel;

  AsignarPersonasMesasEvent(this.listAsignarMesaModel);
}
