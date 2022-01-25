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
  final String tipo_doc;
  VerContratosVer(this.archivo, this.tipo_mime, this.tipo_doc);

  String get prop => archivo;
}

class DescargarArchivoSubidoState extends VerContratosState {
  final String subido;
  final String tipo_mime;
  final String nombre;
  DescargarArchivoSubidoState(this.subido, this.tipo_mime, this.nombre);

  String get prop => subido;
  String get propd => tipo_mime;
  String get propdd => nombre;
}

class DescargarContratoSubidoState extends VerContratosState {
  final String subido;
  final String tipo_mime;
  final String nombre;
  DescargarContratoSubidoState(this.subido, this.tipo_mime, this.nombre);

  String get prop => subido;
  String get propd => tipo_mime;
  String get propdd => nombre;
}

class VerContratoSubidoState extends VerContratosState {
  final String subido;
  final String tipo_mime;
  final String nombre;
  VerContratoSubidoState(this.subido, this.tipo_mime, this.nombre);
  String get prop => subido;
  String get propd => tipo_mime;
  String get propdd => nombre;
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
