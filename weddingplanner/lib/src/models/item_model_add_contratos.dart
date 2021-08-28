class ItemModelAddContratos {
  List<_Contratos> _contratos = []; // lista

  // constructor
  ItemModelAddContratos(this._contratos);

  // llenamos la lista
  ItemModelAddContratos.fromJson(List<dynamic> pardedJson) {
    List<_Contratos> temp = []; // lista temp

    // extramos los datos | llenamos lista - metodo forEach
    pardedJson.forEach((data) {
      temp.add(_Contratos(data));
    });

    _contratos = temp;
  }

  // data
  List<_Contratos> get contrato => _contratos;
}

class _Contratos {
  // variables
  int _idMachote;
  String _descripcion;
  String _machote;
  String _clavePlantilla;

  // constructor
  _Contratos(consulta) {
    _idMachote = consulta['id_machote'];
    _descripcion = consulta['descripcion'];
    _machote = consulta['machote'];
    _clavePlantilla = consulta['clave_plantilla'];
  }

  // ini getters
  int get idMachote => this._idMachote;
  String get descripcion => this._descripcion;
  String get machote => this._machote;
  String get clavePlantilla => this._clavePlantilla;

  // ini setters
  set idMachote(value) => this._idMachote;
  set descripcion(value) => this._descripcion;
  set machote(value) => this._machote;
  set clavePlantilla(value) => this._clavePlantilla;
}