class ItemModelMesas {
  
  List<_Mesas> _results = [];

  ItemModelMesas.fromJson(List<dynamic> parsedJson){
    List<_Mesas> temp = [];
    _Mesas dat = _Mesas({"id_mesa":0, "tipo_mesa":"Seleccionar mesa"});
    temp.add(dat);
    for (int i = 0; i < parsedJson.length; i++) {
      _Mesas result = _Mesas(parsedJson[i]);
      //print(parsedJson[i]);
      temp.add(result);
    }
    //dat = _Mesas({"id_mesa":parsedJson.length + 1, "mesa":"Nuevo grupo"});
    //temp.add(dat);
    _results = temp;
  }
  List<_Mesas> get results => _results;
}

class _Mesas {
  String _mesa;
  int _idMesa;

  _Mesas(datos){
    _mesa = datos['tipo_mesa'];
    _idMesa = datos['id_mesa'];
  }

  String get mesa =>_mesa;
  int get idMesa =>_idMesa;
}