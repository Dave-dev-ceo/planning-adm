import 'dart:convert';

QrInvitadoModel qrInvitadoModelFromJson(String str) =>
    QrInvitadoModel.fromJson(json.decode(str));

String qrInvitadoModelToJson(QrInvitadoModel data) =>
    json.encode(data.toJson());

class QrInvitadoModel {
  QrInvitadoModel({
    this.idInvitado,
    this.nombre,
    this.correo,
    this.grupo,
    this.mesa,
    this.evento,
    this.telefono,
    this.alergias,
    this.alimentacion,
    this.asistenciaEspecial,
    this.acompanantes,
    this.otros,
  });

  int idInvitado;
  String nombre;
  String correo;
  String grupo;
  dynamic mesa;
  String evento;
  String telefono;
  String alergias;
  String alimentacion;
  String asistenciaEspecial;
  String otros;
  List<Acompanante> acompanantes;

  factory QrInvitadoModel.fromJson(Map<String, dynamic> json) =>
      QrInvitadoModel(
        idInvitado: json["id_invitado"],
        nombre: json["nombre"],
        correo: json["correo"],
        grupo: json["grupo"],
        mesa: json["mesa"],
        evento: json["evento"],
        telefono: json["telefono"],
        alergias: json["alergias"],
        alimentacion: json["alimentacion"],
        asistenciaEspecial: json["asistencia_especial"],
        otros: json["otros"],
        acompanantes: List<Acompanante>.from(
            json["acompanantes"].map((x) => Acompanante.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_invitado": idInvitado,
        "nombre": nombre,
        "correo": correo,
        "grupo": grupo,
        "mesa": mesa,
        "evento": evento,
        "telefono": telefono,
        "acompanantes": List<dynamic>.from(acompanantes.map((x) => x.toJson())),
        "otros": otros,
      };
}

class Acompanante {
  Acompanante({
    this.nombre,
    this.mesa,
    this.alimentacion,
    this.alergias,
    this.asistenciaEspecial,
  });

  String nombre;
  String mesa;
  String alimentacion;
  String alergias;
  String asistenciaEspecial;

  factory Acompanante.fromJson(Map<String, dynamic> acompanante) => Acompanante(
        nombre: acompanante["nombre"],
        mesa: acompanante["mesa"],
        alimentacion: acompanante["alimentacion"],
        alergias: acompanante["acompanante"],
        asistenciaEspecial: acompanante["asistenciaEspecial"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
      };
}
