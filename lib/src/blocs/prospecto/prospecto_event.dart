part of 'prospecto_bloc.dart';

@immutable
abstract class ProspectoEvent {}

class MostrarEtapasEvent extends ProspectoEvent {}

class AddProspectoEvent extends ProspectoEvent {
  final ProspectoModel newProspecto;

  AddProspectoEvent(this.newProspecto);

  List<Object> get props => [newProspecto];
}

class UpdateEtapaProspectoEvent extends ProspectoEvent {
  final int? idProspecto;
  final int? idEtapa;

  UpdateEtapaProspectoEvent({this.idProspecto, this.idEtapa});

  List<Object?> get props => [idEtapa, idProspecto];
}

class UpdateEtapaEvent extends ProspectoEvent {
  final List<UpdateEtapaModel> listEtapasUpdate;

  UpdateEtapaEvent({
    required this.listEtapasUpdate,
  });

  List<Object> get props => [listEtapasUpdate];
}

class AddEtapaEvent extends ProspectoEvent {
  final EtapasModel newEtapa;

  AddEtapaEvent(this.newEtapa);
}

class UpdateNameProspecto extends ProspectoEvent {
  final ProspectoModel editProspecto;

  UpdateNameProspecto(this.editProspecto);

  List<Object> get props => [editProspecto];
}

class UpdateTelefonoProspecto extends ProspectoEvent {
  final ProspectoModel editProspecto;

  UpdateTelefonoProspecto(this.editProspecto);

  List<Object> get props => [editProspecto];
}

class UpdateCorreoProspecto extends ProspectoEvent {
  final ProspectoModel editProspecto;

  UpdateCorreoProspecto(this.editProspecto);

  List<Object> get props => [editProspecto];
}

class UpdateDescripcionProspecto extends ProspectoEvent {
  final ProspectoModel editProspecto;

  UpdateDescripcionProspecto(this.editProspecto);

  List<Object> get props => [editProspecto];
}

class InsertActividadProspecto extends ProspectoEvent {
  final ActividadProspectoModel newActividad;

  InsertActividadProspecto(this.newActividad);

  List<Object> get props => [newActividad];
}

class EditNameEtapaEvent extends ProspectoEvent {
  final EtapasModel etapaToEdit;

  EditNameEtapaEvent(this.etapaToEdit);

  List<Object> get props => [etapaToEdit];
}

class DeleteEtapaEvent extends ProspectoEvent {
  final int? idEtapa;

  DeleteEtapaEvent(this.idEtapa);
}

class DeleteActividadEvent extends ProspectoEvent {
  final int? idActividad;

  DeleteActividadEvent(this.idActividad);
}

class UpdateActividadEvent extends ProspectoEvent {
  final ActividadProspectoModel actividadToEdit;

  UpdateActividadEvent(this.actividadToEdit);
}

class UpdateDatosEtapa extends ProspectoEvent {
  final EtapasModel estapaToEdit;

  UpdateDatosEtapa(this.estapaToEdit);
}

class EditInvolucradoEvent extends ProspectoEvent {
  final ProspectoModel prospectoModel;

  EditInvolucradoEvent(this.prospectoModel);
}

class EventoFromProspectoEvent extends ProspectoEvent {
  final int? idProspecto;

  EventoFromProspectoEvent(this.idProspecto);
  List<Object?> get props => [idProspecto];
}

class DeleteProspectoEvent extends ProspectoEvent {
  final int? idProspecto;

  DeleteProspectoEvent(this.idProspecto);

  List<Object?> get props => [idProspecto];
}
