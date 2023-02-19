class HistorialPagosModel {
  HistorialPagosModel({
    this.idPago,
    this.pago,
    this.fecha,
    this.idEvento,
    this.tipoPresupuesto,
    this.concepto,
  });

  int? idPago;
  double? pago;
  DateTime? fecha;
  int? idEvento;
  String? tipoPresupuesto;
  String? concepto;

  factory HistorialPagosModel.fromJson(Map<String, dynamic> json) =>
      HistorialPagosModel(
        idPago: json['id_pago'],
        pago: double.parse(json['pago']),
        fecha: DateTime.tryParse(json['fecha'])!.toLocal(),
        idEvento: json['id_evento'],
        tipoPresupuesto: json['tipo_presupuesto'],
        concepto: json['concepto'],
      );

  Map<String, dynamic> toJson() => {
        'id_pago': idPago,
        'pago': pago,
        'fecha': fecha.toString(),
        'id_evento': idEvento,
        'tipo_presupuesto': tipoPresupuesto,
        'concepto': concepto,
      };
}
