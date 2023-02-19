part of 'perfil_bloc.dart';

@immutable
abstract class PerfilEvent {}

// evento
class SelectPerfilEvent extends PerfilEvent {
  SelectPerfilEvent();
}

class InsertPerfilEvent extends PerfilEvent {
  final Object? perfil;
  InsertPerfilEvent(this.perfil);
  Object? get props => perfil;
}

class PerfilPlannerEvent extends PerfilEvent {
  PerfilPlannerEvent();
}

class EditPerfilPlannerEvent extends PerfilEvent {
  final PerfilPlannerModel perfilplanner;

  EditPerfilPlannerEvent(this.perfilplanner);
}
