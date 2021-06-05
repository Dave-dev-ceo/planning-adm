class ItemModelPaises {
  
  List<_Paises> _results = [];

  ItemModelPaises.fromJson(Map<String, dynamic> parsedJson){
    List<_Paises> temp = [];
    _Paises dat = _Paises({"id_pais":0, "pais":"Sin país", "prefijo":"0"});
    temp.add(dat);
    for (int i = 0; i < parsedJson['data'].length; i++) {
      _Paises result = _Paises(parsedJson[i]);
      //print(parsedJson[i]);
      temp.add(result);
    }
    //dat = _Paises({"id_mesa":parsedJson.length + 1, "mesa":"Nuevo grupo"});
    //temp.add(dat);
    _results = temp;
  }
  List<_Paises> get results => _results;
}

class _Paises {
  String _prefijo;
  String _pais;
  int _idPais;

  _Paises(datos){
    _prefijo = datos['prefijo'];
    _pais = datos['pais'];
    _idPais = datos['id_pais'];
  }
  String get prefijo => _prefijo;
  String get pais =>_pais;
  int get idPais =>_idPais;
}