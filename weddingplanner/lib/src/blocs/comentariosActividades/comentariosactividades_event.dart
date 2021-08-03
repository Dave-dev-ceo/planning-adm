part of 'comentariosactividades_bloc.dart';

@immutable
abstract class ComentariosactividadesEvent {}

// evento - buscar
class SelectComentarioPorIdEvent extends ComentariosactividadesEvent {
  SelectComentarioPorIdEvent();
}

// evento - crear
class CreateComentarioEvent extends ComentariosactividadesEvent {
  final int idActividad;
  final bool estadoComentario;
  final String txtComentario;

  CreateComentarioEvent(
    this.idActividad,
    this.estadoComentario,
    this.txtComentario,
  );

  List<Object> get props => [
    idActividad,
    estadoComentario,
    txtComentario,
  ];
}

// evento actualizar
class UpdateComentarioEvent extends ComentariosactividadesEvent {
  final int idComentario;
  final bool estadoComentario;
  final String txtComentario;

  UpdateComentarioEvent(
    this.idComentario,
    this.estadoComentario,
    this.txtComentario,
  );

  List<Object> get props => [
    idComentario,
    estadoComentario,
    txtComentario,
  ];
}