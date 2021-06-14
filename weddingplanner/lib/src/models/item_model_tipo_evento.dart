class ItemModelTipoEvento {
  
  List<Evento> _results = [];

  ItemModelTipoEvento.fromJson(List<dynamic> parsedJson){
    List<Evento> temp = [];
    //_Evento dat = _Evento({"id_grupo":0, "nombre_grupo":"Seleccionar grupo"});
    //temp.add(dat);
    for (int i = 0; i < parsedJson.length; i++) {
      Evento result = Evento(parsedJson[i]);
      //print(parsedJson[i]);
      temp.add(result);
    }
    ///dat = _Evento({"id_grupo":parsedJson.length + 1, "nombre_grupo":"Nuevo grupo"});
    //temp.add(dat);
    _results = temp;
  }
  List<Evento> get results => _results;
}

class Evento {
  String _nombreEvento;
  int _idTipoEvento;

  Evento(datos){
    _nombreEvento = datos['tipo'];
    _idTipoEvento = datos['id_tipo_evento'];
  }

  String get nombreEvento =>_nombreEvento;
  int get idTipoEvento =>_idTipoEvento;
}