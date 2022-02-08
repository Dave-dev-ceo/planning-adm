class ItemModelReporteInvitados {
  List<_Estatus> _results = [];

  ItemModelReporteInvitados.fromJson(List<dynamic> parsedJson) {
    List<_Estatus> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _Estatus result = _Estatus(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_Estatus> get results => _results;
}

class _Estatus {
  String _estatus;
  String _cantidad;

  _Estatus(datos) {
    _estatus = datos['estatus'] ?? 'Sin estatus';
    _cantidad = datos['cantidad'];
  }

  String get estatus => _estatus;
  String get cantidad => _cantidad;
}
