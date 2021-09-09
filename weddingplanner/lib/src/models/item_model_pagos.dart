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
  int _idConcepto;
  int _cantidad;
  int _idServicio;
  int _idProveedor;
  String _descripcion;
  int _precioUnitario;
  int _total;
  int _anticipo;
  int _saldo;

  _Pagos(data) {
    _idConcepto = data['id_concepto'];
    _cantidad = data['cantidad'];
    _idServicio = data['id_servicio'];
    _idProveedor = data['id_proveedor'];
    _descripcion = data['descripcion'];
    _precioUnitario = data['precio_unitario'];
    _total = data['total'];
    _anticipo = data['anticipo'];
    _saldo = data['saldo'];
  }

  int get idConcepto => this._idConcepto;
  int get cantidad => this._cantidad;
  int get idServicio => this._idServicio;
  int get idProveedor => this._idProveedor;
  String get descripcion => this._descripcion;
  int get precioUnitario => this._precioUnitario;
  int get total => this._total;
  int get anticipo => this._anticipo;
  int get saldo => this._saldo;

  set idConcepto(value) => this._idConcepto;
  set cantidad(value) => this._cantidad;
  set idServicio(value) => this._idServicio;
  set idProveedor(value) => this._idProveedor;
  set descripcion(value) => this._descripcion;
  set precioUnitario(value) => this._precioUnitario;
  set total(value) => this._total;
  set anticipo(value) => this._anticipo;
  set saldo(value) => this._saldo;
}
