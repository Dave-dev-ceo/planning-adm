class InvitadosMesaModel {
  InvitadosMesaModel({
    this.idInvitado,
    this.idMesa,
    this.idEvento,
    this.nombre,
    this.acompanantes,
  });

  int idInvitado;
  int idMesa;
  int idEvento;
  String nombre;
  List<AcompananteModel> acompanantes;

  factory InvitadosMesaModel.fromJson(Map<String, dynamic> json) =>
      InvitadosMesaModel(
        idInvitado: json['id_invitado'],
        idMesa: json['id_mesa'],
        idEvento: json['id_evento'],
        nombre: json['nombre'],
        acompanantes: List<AcompananteModel>.from(
            json['acompanante'].map((a) => AcompananteModel.fromJson(a))),
      );

  Map<String, dynamic> toJson() => {
        'id_invitado': idInvitado,
        'id_mesa': idMesa,
        'id_evento': idEvento,
        'nombre': nombre,
        'acompanantes': acompanantes.map((e) => e.toJson()).toList(),
      };
}

class AcompananteModel {
  AcompananteModel({
    this.idAcompanante,
    this.nombre,
    this.idEvento,
    this.idInvitado,
    this.idMesa,
  });
  int idAcompanante;
  String nombre;
  int idEvento;
  int idInvitado;
  int idMesa;

  factory AcompananteModel.fromJson(Map<String, dynamic> json) =>
      AcompananteModel(
        idAcompanante: json['id_acompanante'],
        nombre: json['nombre'],
        idEvento: json['id_evento'],
        idInvitado: json['id_invitado'],
        idMesa: json['id_mesa'],
      );

  Map<String, dynamic> toJson() => {
        'id_acompanante': idAcompanante,
        'nombre': nombre,
        'id_evento': idEvento,
        'id_invitado': idInvitado,
        'id_mesa': idMesa,
      };
}
