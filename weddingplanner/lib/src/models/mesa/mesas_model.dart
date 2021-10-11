class MesasModel {
  MesasModel({
    this.idMesa,
    this.nombre,
    this.dimension,
    this.numeroDeMesa,
    this.idEvento,
    this.asignados,
  });

  int idMesa;
  String nombre;
  int dimension;
  int numeroDeMesa;
  int idEvento;
  List<Asignados> asignados;

  factory MesasModel.fromJson(Map<String, dynamic> json) => MesasModel(
        idMesa: json['id_mesa'],
        nombre: json['nombre'],
        dimension: json['dimencion'],
        numeroDeMesa: json['numero_mesa'],
        idEvento: json['id_evento'],
        asignados: List<Asignados>.from(
            json['asignados'].map((e) => Asignados.fromJson(e))),
      );
}

class Asignados {
  Asignados({
    this.idMesaAsignada,
    this.mesa,
    this.asignado,
    this.evento,
    this.planner,
    this.posicion,
    this.numeroDeMesa,
  });
  int idMesaAsignada;
  String mesa;
  String asignado;
  String evento;
  String planner;
  int posicion;
  int numeroDeMesa;

  factory Asignados.fromJson(Map<String, dynamic> json) => Asignados(
        idMesaAsignada: json['id_mesa_asignada'],
        mesa: json['mesa'],
        asignado: json['asignado'],
        evento: json['evento'],
        planner: json['planner'],
        posicion: json['posicion'],
        numeroDeMesa: json['numero_mesa'],
      );

  Map<String, dynamic> toJson() => {
        'id_mesa_asignada': idMesaAsignada,
        'mesa': mesa,
        'asignado': asignado,
        'evento': evento,
        'planner': planner,
        'posicion': posicion,
        'numero_mesa': numeroDeMesa,
      };
}
