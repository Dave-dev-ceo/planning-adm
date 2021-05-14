class ItemModelTipoEvento {
  
  List<_Evento> _results = [];

  ItemModelTipoEvento.fromJson(List<dynamic> parsedJson){
    List<_Evento> temp = [];
    //_Evento dat = _Evento({"id_grupo":0, "nombre_grupo":"Seleccionar grupo"});
    //temp.add(dat);
    for (int i = 0; i < parsedJson.length; i++) {
      _Evento result = _Evento(parsedJson[i]);
      //print(parsedJson[i]);
      temp.add(result);
    }
    ///dat = _Evento({"id_grupo":parsedJson.length + 1, "nombre_grupo":"Nuevo grupo"});
    //temp.add(dat);
    _results = temp;
  }
  List<_Evento> get results => _results;
}

class _Evento {
  String _nombreEvento;
  int _idTipoEvento;

  _Evento(datos){
    _nombreEvento = datos['nombre_grupo'];
    _idTipoEvento = datos['id_grupo'];
  }

  String get nombreEvento =>_nombreEvento;
  int get idTipoEvento =>_idTipoEvento;
}