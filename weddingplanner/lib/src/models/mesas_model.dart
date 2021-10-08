class MesasModel {
  MesasModel({
    this.idMesaAsignada,
    this.mesa,
    this.invitado,
    this.acompanante,
    this.evento,
    this.planner,
  });
  int idMesaAsignada;
  String mesa;
  String invitado;
  String acompanante;
  String evento;
  String planner;

  factory MesasModel.fromJson(Map<String, dynamic> json) => MesasModel(
        idMesaAsignada: json['id_mesa_asignada'],
        mesa: json['mesa'],
        invitado: json['invitado'],
        acompanante: json['acompanante'],
        evento: json['evento'],
        planner: json['planner'],
      );

  Map<String, dynamic> toJson() => {
        'id_mesa_mesignada': idMesaAsignada,
        'mesa': mesa,
        'invitado': invitado,
        'acompanante': acompanante,
        'evento': evento,
        'planner': planner,
      };
}
