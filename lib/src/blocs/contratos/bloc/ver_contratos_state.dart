part of 'ver_contratos_bloc.dart';

@immutable
abstract class VerContratosState {}

class VerContratosInitial extends VerContratosState {}

class VerContratosLoggin extends VerContratosState {}

class VerContratosBorrar extends VerContratosState {}

class VerContratosSubir extends VerContratosState {}

class CrearContratoState extends VerContratosState {}

class VerContratosVer extends VerContratosState {
  final String archivo;
  final String tipo_mime;
  VerContratosVer(this.archivo, this.tipo_mime);

  String get prop => archivo;
}

class DescargarContratoState extends VerContratosState {
  final String nombre;
  final String archivo;
  final String extencion;

  DescargarContratoState(this.nombre, this.archivo, this.extencion);

  String get props => nombre;
  String get prop => archivo;
  String get prod => extencion;
}

class AutorizacionErrorState extends VerContratosState {
  final String message;

  AutorizacionErrorState(this.message);

  List<Object> get props => [message];
}

class AutorizacionTokenErrorState extends VerContratosState {
  final String message;

  AutorizacionTokenErrorState(this.message);

  List<Object> get props => [message];
}
