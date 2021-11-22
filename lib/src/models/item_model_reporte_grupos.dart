class ItemModelReporteGrupos {
  List<_Grupos> _results = [];

  ItemModelReporteGrupos.fromJson(List<dynamic> parsedJson) {
    List<_Grupos> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _Grupos result = _Grupos(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_Grupos> get results => _results;
}

class _Grupos {
  String _grupo;
  String _cantidad;

  _Grupos(datos) {
    _grupo = datos['grupo'] == null ? 'Sin grupo' : datos['grupo'];
    _cantidad = datos['cantidad'];
  }

  String get grupo => _grupo;
  String get cantidad => _cantidad;
}
