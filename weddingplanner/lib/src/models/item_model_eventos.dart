class ItemModelEventos {
  List<Evento> _results = [];

  ItemModelEventos.fromJson(Map<dynamic, dynamic> parsedJson) {
    List<Evento> temp = [];
    for (int i = 0; i < parsedJson['evento'].length; i++) {
      Evento result = Evento(parsedJson['evento'][i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<Evento> get results => _results;

  ItemModelEventos.fromJsonUnit(Map<dynamic, dynamic> parsedJson) {
    List<Evento> temp = [];
    for (int i = 0; i < parsedJson['evento'].length; i++) {
      Evento result = Evento(parsedJson['evento'][i]);
      temp.add(result);
    }
    _results = temp;
  }
}

class Evento {
  int _idEvento;
  String _fechaInicio;
  String _fechaFin;
  String _fechaEvento;
  String _tipoEvento;
  List<Involucrados> _involucrados = [];
  Evento(datos) {
    _idEvento = datos['id_evento'];
    _fechaInicio = datos['fecha_inicio'];
    _fechaFin = datos['fecha_fin'];
    _tipoEvento = datos['tipo_evento'];
    _fechaEvento = datos['fecha_evento'];

    List<Involucrados> tempI = [];
    for (var i = 0; i < datos['involucrados'].length; i++) {
      Involucrados invo = Involucrados(datos['involucrados'][i]);
      tempI.add(invo);
    }
    _involucrados = tempI;
  }

  int get idEvento => _idEvento;
  String get fechaInicio => _fechaInicio;
  String get fechaFin => _fechaFin;
  String get fechaEvento => _fechaEvento;
  String get tipoEvento => _tipoEvento;
  List<Involucrados> get involucrados => _involucrados;
}

class Involucrados {
  String _nombre;
  String _tipoInvolucrado;

  Involucrados(datos) {
    _nombre = datos['nombre'];
    _tipoInvolucrado = datos['tipo_involucrado'];
  }

  String get nombre => _nombre;
  String get tipoInvolucrado => _tipoInvolucrado;
}
