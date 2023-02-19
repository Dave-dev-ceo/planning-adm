class PagoPresupuesto {
  PagoPresupuesto({
    this.servicioId = '0',
    this.proveedoresId = '0',
    this.cantidad,
    this.precioUnitario,
    this.precioUnitarioAdicional,
    this.concepto,
    this.precioAdicional = true,
    this.tipoPresupuesto,
  });

  String? servicioId;
  String? proveedoresId;
  int? cantidad;
  double? precioUnitario;
  double? precioUnitarioAdicional;
  bool? precioAdicional;
  String? concepto;
  String? tipoPresupuesto;

  Map<String, dynamic> toJson() => {
        'servicios': servicioId,
        'proveedores': proveedoresId,
        'cantidad': cantidad,
        'concepto': concepto,
        'precio': precioUnitario,
        'tipoPresupuesto': tipoPresupuesto,
        'precioUnitarioAdicional': precioUnitarioAdicional,
      };
}
