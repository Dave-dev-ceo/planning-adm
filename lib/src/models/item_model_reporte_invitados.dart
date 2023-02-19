class ItemModelReporteInvitados {
  List<Estatus> _results = [];

  ItemModelReporteInvitados.fromJson(List<dynamic> parsedJson) {
    List<Estatus> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      Estatus result = Estatus(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<Estatus> get results => _results;
}

class Estatus {
  String? _estatus;
  String? _cantidad;

  Estatus(datos) {
    _estatus = datos['estatus'] ?? 'Sin estatus';
    _cantidad = datos['cantidad'];
  }

  String? get estatus => _estatus;
  String? get cantidad => _cantidad;
}
