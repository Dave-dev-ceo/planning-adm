class MesaModel {
  MesaModel({
    this.idMesa,
    this.descripcion,
    this.idEvento,
    this.idTipoDeMesa,
    this.estatus,
    this.dimension,
    this.numDeMesa,
  });

  int idMesa;
  String descripcion;
  int idEvento;
  int idTipoDeMesa;
  String estatus;
  int dimension;
  int numDeMesa;

  factory MesaModel.fromJson(Map<String, dynamic> json) => MesaModel(
        idMesa: json['id_mesa'],
        descripcion: json['descripcion'],
        idEvento: json['id_evento'],
        idTipoDeMesa: json['id_tipo_mesa'],
        estatus: json['estatus'],
        dimension: json['dimencion'],
        numDeMesa: json['numero_mesa'],
      );
  Map<String, dynamic> toJson() => {
        'id_mesa': idMesa,
        'descripcion': descripcion,
        'id_evento': idEvento,
        'id_tipo_mesa': idTipoDeMesa,
        'estatus': estatus,
        'dimencion': dimension,
        'numero_mesa': numDeMesa,
      };
}
