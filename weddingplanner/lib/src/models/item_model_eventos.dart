class ItemModelEventos{
  List<_Evento> _results = []; 

  ItemModelEventos.fromJson(Map<dynamic,dynamic> parsedJson){
    List<_Evento> temp = [];
    for (int i = 0; i < parsedJson['evento'].length; i++) {
        _Evento result = _Evento(parsedJson['evento'][i]);
        temp.add(result);
    }
    _results = temp;
  }
  List<_Evento> get results => _results;
}

class _Evento{
  int _idEvento;
  String _fechaInicio;
  String _fechaFin;
  String _tipoEvento;
  List <_Involucrados> _involucrados = [];
  _Evento(datos){
    _idEvento = datos['id_evento'];
    _fechaInicio = datos['fecha_inicio'];
    _fechaFin = datos['fecha_fin'];
    _tipoEvento = datos['tipo_evento'];
    
    List<_Involucrados> tempI =[];
    for (var i = 0; i < datos['involucrados'].length; i++) {
      _Involucrados invo = _Involucrados(datos['involucrados'][i]);
      tempI.add(invo);  
    }
    _involucrados = tempI;

  }

  int get idEvento => _idEvento;
  String get fechaInicio => _fechaInicio;
  String get fechaFin => _fechaFin;
  String get tipoEvento => _tipoEvento;
  List<_Involucrados> get involucrados => _involucrados;   
}

class _Involucrados {
  String _nombre;
  String _tipoInvolucrado;

  _Involucrados(datos){
    _nombre = datos['nombre'];
    _tipoInvolucrado = datos['tipo_involucrado'];
  }

  String get nombre => _nombre;
  String get tipoInvolucrado => _tipoInvolucrado;
}