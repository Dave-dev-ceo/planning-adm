part of 'ver_contratos_bloc.dart';

@immutable
abstract class VerContratosEvent {}

class BorrarContrato extends VerContratosEvent {
  final int? id;

  BorrarContrato(this.id);

  int? get prop => id;
}

class SubirContrato extends VerContratosEvent {
  final int? id;
  final String archivo;
  final String tipoDoc;
  final String? tipoMime;

  SubirContrato(this.id, this.archivo, this.tipoDoc, this.tipoMime);

  int? get pro => id;
  String get prop => archivo;
}

class VerContrato extends VerContratosEvent {
  final int? idContrato;
  final String? tipoMime;
  final String? tipoDoc;
  VerContrato(this.idContrato, this.tipoMime, this.tipoDoc);

  int? get prod => idContrato;
  String? get propp => tipoMime;
}

class VerContratoSubido extends VerContratosEvent {
  final int? idContrato;
  final String? tipoMime;
  final String? tipoDoc;

  VerContratoSubido(this.idContrato, this.tipoMime, this.tipoDoc);

  int? get prop => idContrato;
}

class DescargarArchivoSubidoEvent extends VerContratosEvent {
  final int? idContrato;
  final String? tipoMime;
  final String? nombre;
  DescargarArchivoSubidoEvent(this.idContrato, this.tipoMime, this.nombre);
  int? get prop => idContrato;
  String? get propd => tipoMime;
  String? get propds => nombre;
}

class DescargarContratoSubidoEvent extends VerContratosEvent {
  final int? idContrato;
  final String? tipoMime;
  final String? nombre;
  DescargarContratoSubidoEvent(this.idContrato, this.tipoMime, this.nombre);
  int? get prop => idContrato;
  String? get propd => tipoMime;
  String? get propds => nombre;
}

class VerContratoSubidoEvent extends VerContratosEvent {
  final int? idContrato;
  final String? tipoMime;
  final String? nombre;
  VerContratoSubidoEvent(this.idContrato, this.tipoMime, this.nombre);
  int? get prop => idContrato;
  String? get propd => tipoMime;
  String? get propds => nombre;
}

class DescargarContrato extends VerContratosEvent {
  final String? nombre;
  final int? idContrato;
  final String? tipoMime;

  DescargarContrato(this.nombre, this.idContrato, this.tipoMime);

  String? get props => nombre;
  int? get prop => idContrato;
  String? get propsd => tipoMime;
}

class CrearContrato extends VerContratosEvent {
  final String nombre;
  final String archivo;
  final String? clave;
  final String tipoDoc;
  final String? tipoMime;

  CrearContrato(
      this.nombre, this.archivo, this.clave, this.tipoDoc, this.tipoMime);

  String get props => nombre;
  String get prop => archivo;
  String? get pro => clave;
  String get prod => tipoDoc;
  String? get prodd => tipoMime;
}
