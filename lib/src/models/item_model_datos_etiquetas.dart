class ItemModelEtiquetas {
  List<Etiquetas> _results = [];

  ItemModelEtiquetas.fromJson(List<dynamic> parsedJson) {
    List<Etiquetas> temp = [];
    /*Etiquetas dat = Etiquetas({"id_estatus_invitado":0, "descripcion":"Sin estatus"});
    temp.add(dat);*/
    for (int i = 0; i < parsedJson.length; i++) {
      Etiquetas result = Etiquetas(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<Etiquetas> get results => _results;
}

class Etiquetas {
  String? _nombreEtiqueta;
  String? _tipoEtiqueta;
  int? _idEtiqueta;

  Etiquetas(datos) {
    _nombreEtiqueta = datos['nombre_etiqueta'];
    _idEtiqueta = datos['id_etiqueta'];
    _tipoEtiqueta = datos['tipo_etiqueta'];
  }
  set addNombreEtiqueta(String data) {
    _nombreEtiqueta = data;
  }

  set addTipoEtiqueta(String data) {
    _tipoEtiqueta = data;
  }

  String? get nombreEtiqueta => _nombreEtiqueta;
  String? get tipoEtiqueta => _tipoEtiqueta;
  int? get idEtiqueta => _idEtiqueta;
}
