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

  SubirContrato(this.id,this.archivo);

  int get pro => id;
  String get prop => archivo;
}

class VerContrato extends VerContratosEvent {
  final String archivo;

  VerContrato(this.archivo);

  String get prop => archivo;
}

class VerContratoSubido extends VerContratosEvent {
  final String archivo;

  VerContratoSubido(this.archivo);

  String get prop => archivo;
}

class DescargarContrato extends VerContratosEvent {
  final String nombre;
  final String archivo;

  DescargarContrato(this.nombre,this.archivo);

  String get props => nombre;
  String get prop => archivo;
}

class CrearContrato extends VerContratosEvent {
  final String nombre;
  final String archivo;
  final String clave;

  CrearContrato(this.nombre,this.archivo,this.clave);

  String get props => nombre;
  String get prop => archivo;
  String get pro => clave;
}
