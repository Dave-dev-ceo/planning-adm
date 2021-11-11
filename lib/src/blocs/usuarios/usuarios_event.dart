part of 'usuarios_bloc.dart';

@immutable
abstract class UsuariosEvent {}

class FetchUsuariosPorPlannerEvent extends UsuariosEvent {
  FetchUsuariosPorPlannerEvent();
}
