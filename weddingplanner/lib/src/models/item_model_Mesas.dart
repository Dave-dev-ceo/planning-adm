class EventoModelMesas {
  EventoModelMesas({
    this.descripcion,
    this.dimension,
    this.idTipoMesa,
    this.idEvento,
    this.estatus,
    this.idMesa,
  });
  String descripcion;
  int dimension;
  int idTipoMesa;
  int idEvento;
  String estatus;
  int idMesa;

  factory EventoModelMesas.fromJson(Map<String, dynamic> json) =>
      EventoModelMesas(
        descripcion: json['descripcion'],
        dimension: json['dimension'],
        idTipoMesa: json['id_tipo_mesa'],
        idEvento: json['id_evento'],
        estatus: json['estatus'],
        idMesa: json['id_mesa'],
      );

  Map<String, dynamic> tojson() => {
        'descripcion': descripcion,
        'dimension': dimension,
        'id_tipo_mesa': idTipoMesa,
        'id_evento': idEvento,
        'estatus': estatus,
        'id_mesa': idMesa,
      };
}
