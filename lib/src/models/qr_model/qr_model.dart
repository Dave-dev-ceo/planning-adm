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
    this.acompanantes,
  });

  int idInvitado;
  String nombre;
  String correo;
  String grupo;
  dynamic mesa;
  String evento;
  String telefono;
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
      };
}

class Acompanante {
  Acompanante({
    this.nombre,
  });

  String nombre;

  factory Acompanante.fromJson(String acompanante) => Acompanante(
        nombre: acompanante,
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
      };
}
