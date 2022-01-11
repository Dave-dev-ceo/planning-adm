part of 'ver_contratos_bloc.dart';

@immutable
abstract class VerContratosEvent {}

class BorrarContrato extends VerContratosEvent {
  final int id;

  BorrarContrato(this.id);

  int get prop => id;
}

class SubirContrato extends VerContratosEvent {
  final int id;
  final String archivo;
  final String tipo_doc;
  final String tipo_mime;

  SubirContrato(this.id, this.archivo, this.tipo_doc, this.tipo_mime);

  int get pro => id;
  String get prop => archivo;
}

class VerContrato extends VerContratosEvent {
  final String archivo;
  final String tipo_mime;
  VerContrato(this.archivo, this.tipo_mime);

  String get prop => archivo;
  String get propp => tipo_mime;
}

class VerContratoSubido extends VerContratosEvent {
  final String archivo;
  final String tipo_mime;

  VerContratoSubido(this.archivo, this.tipo_mime);

  String get prop => archivo;
}

class DescargarContrato extends VerContratosEvent {
  final String nombre;
  final String archivo;
  final String tipo_mime;

  DescargarContrato(this.nombre, this.archivo, this.tipo_mime);

  String get props => nombre;
  String get prop => archivo;
  String get propsd => tipo_mime;
}

class CrearContrato extends VerContratosEvent {
  final String nombre;
  final String archivo;
  final String clave;
  final String tipo_doc;
  final String tipo_mime;

  CrearContrato(
      this.nombre, this.archivo, this.clave, this.tipo_doc, this.tipo_mime);

  String get props => nombre;
  String get prop => archivo;
  String get pro => clave;
  String get prod => tipo_doc;
  String get prodd => tipo_mime;
}
