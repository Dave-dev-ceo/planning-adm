part of 'perfil_bloc.dart';

@immutable
abstract class PerfilEvent {}

// evento 
class SelectPerfilEvent extends PerfilEvent {
  SelectPerfilEvent();
}

class InsertPerfilEvent extends PerfilEvent {
  final Object perfil;
  InsertPerfilEvent(this.perfil);
  Object get props => perfil;
}