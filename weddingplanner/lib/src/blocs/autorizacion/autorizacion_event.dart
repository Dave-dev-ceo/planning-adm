part of 'autorizacion_bloc.dart';

@immutable
abstract class AutorizacionEvent {}

// evento - select
class SelectAutorizacionEvent extends AutorizacionEvent {
  SelectAutorizacionEvent();
}

// evento - crear
class CrearAutorizacionEvent extends AutorizacionEvent {
  final Map data;
  CrearAutorizacionEvent(this.data);

  Map get props => data;
}

// evento - select id
class SelectEvidenciaEvent extends AutorizacionEvent {
  final int id;

  SelectEvidenciaEvent(this.id);

  int get props => id;
}

// evento - update
class UpdateAutorizacionEvent extends AutorizacionEvent {
  final int id;
  final String descripcion;
  final String comentario;

  UpdateAutorizacionEvent(this.id, this.descripcion, this.comentario);

  int get props => id;
  String get prop => descripcion;
  String get pro => comentario;
}

// evento - delete
class DeleteAutorizacionEvent extends AutorizacionEvent {
  final int id;

  DeleteAutorizacionEvent(this.id);

  int get props => id;
}

// evento - delete image
class DeleteEvidenciaEvent extends AutorizacionEvent {
  final int id;
  final int autorizacion;

  DeleteEvidenciaEvent(this.id,this.autorizacion);

  int get props => id;
  int get prop => autorizacion;
}

// evento - crear imagen
class CrearImagenEvent extends AutorizacionEvent {
  final Map data;
  CrearImagenEvent(this.data);

  Map get props => data;
}

// evento - update evidencia
class UpdateEvidenciaEvent extends AutorizacionEvent {
  final int idEvidencia;
  final int idAutorizacion;
  final String descripcion;

  UpdateEvidenciaEvent(this.idEvidencia, this.idAutorizacion, this.descripcion);

  int get props => idEvidencia;
  int get prop => idAutorizacion;
  String get pro => descripcion;
}
