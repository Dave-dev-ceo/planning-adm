class ItemModelPagos {
  List<_Pagos> _pagos = [];

  ItemModelPagos(this._pagos);

  ItemModelPagos.fromJson(List<dynamic> json) {
    List<_Pagos> temp = [];

    for (int i = 0; i < json.length; i++) {
      _Pagos result = _Pagos(json[i]);
      temp.add(result);
    }
    _pagos = temp;
  }

  List<_Pagos> get pagos => _pagos;
}

class _Pagos {
  int? _idConcepto;
  int? _cantidad;
  int? _idServicio;
  String? _servicio;
  int? _idProveedor;
  String? _proveedor;
  String? _descripcion;
  double? _precioUnitario;
  double? _total;
  double? _anticipo;
  double? _saldo;
  String? _tipoPresupuesto;

  _Pagos(data) {
    _idConcepto = data['id_concepto'];
    _cantidad = data['cantidad'];
    _idServicio = data['id_servicio'];
    _servicio = data['nombre'];
    _idProveedor = data['id_proveedor'];
    _proveedor = data['nombre'];
    _descripcion = data['descripcion'];
    _precioUnitario = double.tryParse(data['precio_unitario'] ?? '0');
    _total = double.tryParse(data['total'] ?? '0');
    _anticipo = double.tryParse(data['anticipo'] ?? '0');
    _saldo = double.tryParse(data['saldo'] ?? '0');
    _tipoPresupuesto = data['tipo_presupuesto'];
  }

  int? get idConcepto => _idConcepto;
  int? get cantidad => _cantidad;
  int? get idServicio => _idServicio;
  String? get servicio => _servicio;
  int? get idProveedor => _idProveedor;
  String? get proveedor => _proveedor;
  String? get descripcion => _descripcion;
  double? get precioUnitario => _precioUnitario;
  double? get total => _total;
  double? get anticipo => _anticipo;
  double? get saldo => _saldo;
  String? get tipoPresupuesto => _tipoPresupuesto;

  set idConcepto(value) => _idConcepto;
  set cantidad(value) => _cantidad;
  set idServicio(value) => _idServicio;
  set servicio(value) => _servicio;
  set idProveedor(value) => _idProveedor;
  set proveedor(value) => _proveedor;
  set descripcion(value) => _descripcion;
  set precioUnitario(value) => _precioUnitario;
  set total(value) => _total;
  set anticipo(value) => _anticipo;
  set saldo(value) => _saldo;
  set tipoPresupuesto(value) => _tipoPresupuesto;
}
