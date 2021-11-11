class MesasAsignadasModel {
  MesasAsignadasModel({
    this.idMesaAsignada,
    this.idAcompanante,
    this.idEvento,
    this.idInvitado,
    this.idMesa,
    this.idPlanner,
    this.posicion,
    this.acompanante,
    this.invitado,
    this.numMesa,
    this.alimentacion,
    this.alergias,
    this.asistenciaEspecial,
  });
  String invitado;
  String acompanante;
  int idMesaAsignada;
  int idAcompanante;
  int idEvento;
  int idInvitado;
  int idMesa;
  int idPlanner;
  int posicion;
  int numMesa;
  String alimentacion;
  String alergias;
  String asistenciaEspecial;

  factory MesasAsignadasModel.fromJson(Map<String, dynamic> json) =>
      MesasAsignadasModel(
        idMesaAsignada: json['id_mesa_asignada'],
        idAcompanante: json['id_acompanante'],
        idEvento: json['id_evento'],
        idInvitado: json['id_invitado'],
        idMesa: json['id_mesa'],
        idPlanner: json['id_planner'],
        posicion: json['posicion'],
        acompanante: json['acompanante'],
        invitado: json['invitado'],
        numMesa: json['numero_mesa'],
        alimentacion: json['alimentacion'],
        alergias: json['alergias'],
        asistenciaEspecial: json['asistencia_especial'],
      );

  Map<String, dynamic> toJson() => {
        'id_mesa_asignada': idMesaAsignada,
        'id_acompanante': idAcompanante,
        'id_evento': idEvento,
        'id_invitado': idInvitado,
        'id_mesa': idMesa,
        'id_planer': idPlanner,
        'posicion': posicion,
        'acompanante': acompanante,
        'invitado': invitado,
        'numero_mesa': numMesa,
        'alimentacion': alimentacion,
        'alergias': alergias,
        'asistencia_especial': asistenciaEspecial,
      };
}
