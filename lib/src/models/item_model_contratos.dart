class ItemModelContratos {
  List<Contratos> _results = [];

  ItemModelContratos.fromJson(List<dynamic> parsedJson) {
    List<Contratos> temp = [];
    /*Contratos dat = Contratos({"id_estatus_invitado":0, "descripcion":"Sin estatus"});
    temp.add(dat);*/
    for (int i = 0; i < parsedJson.length; i++) {
      Contratos result = Contratos(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<Contratos> get results => _results;
}

class Contratos {
  String? _descripcion;
  String? _contrato;
  int? _idContrato;

  Contratos(datos) {
    _descripcion = datos['descripcion'];
    _idContrato = datos['id_contrato'];
    _contrato = datos['contrato'];
  }
  set addDescripcion(String? data) {
    _descripcion = data;
  }

  set addContrato(String data) {
    _contrato = data;
  }

  String? get descripcion => _descripcion;
  String? get contrato => _contrato;
  int? get idContrato => _idContrato;
}
