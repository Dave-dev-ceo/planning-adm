class ItemModelAddContratos {
  List<_Contratos> _contratos = []; // lista

  // constructor
  ItemModelAddContratos(this._contratos);

  // llenamos la lista
  ItemModelAddContratos.fromJson(List<dynamic> pardedJson) {
    List<_Contratos> temp = []; // lista temp

    // extramos los datos | llenamos lista - metodo forEach
    for (var data in pardedJson) {
      temp.add(_Contratos(data));
    }

    _contratos = temp;
  }

  // data
  List<_Contratos> get contrato => _contratos;
}

class _Contratos {
  // variables
  int? _idMachote;
  int? _idContrato;
  String? _descripcion;
  String? _machote;
  String? _archivo;
  String? _original;
  String? _clavePlantilla;
  String? _tipoDoc;
  String? _tipoMime;
  String? _tipoMimeOriginal;

  // constructor
  _Contratos(consulta) {
    _idMachote = consulta['id_machote'];
    _idContrato = consulta['id_contrato'];
    _descripcion = consulta['descripcion'];
    _machote = consulta['machote'];
    _archivo = consulta['archivo'];
    _original = consulta['original'];
    _clavePlantilla = consulta['clave_plantilla'];
    _tipoDoc = consulta['tipo_doc'];
    _tipoMime = consulta['tipo_mime'];
    _tipoMimeOriginal = consulta['tipo_mime_original'];
  }

  // ini getters
  int? get idMachote => _idMachote;
  int? get idContrato => _idContrato;
  String? get descripcion => _descripcion;
  String? get machote => _machote;
  String? get archivo => _archivo;
  String? get original => _original;
  String? get clavePlantilla => _clavePlantilla;
  String? get tipoDoc => _tipoDoc;
  String? get tipoMime => _tipoMime;
  String? get tipoMimeOriginal => _tipoMimeOriginal;

  // ini setters
  set idMachote(value) => _idMachote;
  set idContrato(value) => _idContrato;
  set descripcion(value) => _descripcion;
  set machote(value) => _machote;
  set archivo(value) => _archivo;
  set original(value) => _original;
  set clavePlantilla(value) => _clavePlantilla;
  set tipoDoc(value) => _tipoDoc;
  set tipoMime(value) => _tipoMime;
  set tipoMimeOriginal(value) => _tipoMimeOriginal;
}
